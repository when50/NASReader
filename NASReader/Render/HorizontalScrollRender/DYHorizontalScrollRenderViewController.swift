//
//  DYHorizontalScrollRenderViewController.swift
//  NASReader
//
//  Created by oneko.c on 2022/8/4.
//

import UIKit

class DYHorizontalScrollRenderViewController: UIViewController, DYRenderProtocol, UIScrollViewDelegate {
    struct Constant {
        static let gap: CGFloat = 20.0
    }
    var delegate: DYRenderDelegate?
    private(set) var canvas: UIScrollView!
    private var allPages: [Int: UIView] = [:]
    
    var dataSource: DYRenderDataSource? {
        didSet {
            scrollViewDidScroll(self.canvas)
        }
    }
    
    func supportStyle(style: DYRenderModel.Style) -> Bool {
        return DYRenderModel.Style.scrollHorizontal == style
    }
    
    func scrollBackwardPage(animated: Bool) {
        scrollToCurrentPage(animated: animated)
    }
    
    func scrollForwardPage(animated: Bool) {
        scrollToCurrentPage(animated: animated)
    }
    
    private func scrollToCurrentPage(animated: Bool) {
        guard let dataSource = dataSource else {
            return
        }
        let width = canvas.frame.size.width
        removeInvisiblePages()
        setupPages()
        let offset = CGPoint(x: dataSource.currentPageIdx * Int(width), y: 0)
        canvas.setContentOffset(offset, animated: animated)
    }
    
    
    override func loadView() {
        let view = UIView()
        
        let canvas = UIScrollView(frame: .zero)
        canvas.translatesAutoresizingMaskIntoConstraints = false
        canvas.isPagingEnabled = true
        canvas.delegate = self
        canvas.showsVerticalScrollIndicator = false
        canvas.showsHorizontalScrollIndicator = false
        view.addSubview(canvas)
        
        self.canvas = canvas
        self.view = view
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func handleTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        let range = view.frame.size.width
        if range > 0 {
            processTapAt(location: Float(location.x / range))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollViewDidScroll(canvas)
    }
    
    override func viewWillLayoutSubviews() {
        canvas.frame = view.bounds
        let width = canvas.frame.size.width
        let height = canvas.frame.size.height
        canvas.contentInset = .zero
        canvas.contentSize = CGSize(width: CGFloat(dataSource?.pageNum ?? 0) * width, height: height)
        canvas.contentOffset = CGPoint(x: CGFloat(dataSource?.currentPageIdx ?? 0) * width, y: 0)
        
        allPages.forEach { (key: Int, value: UIView) in
            value.frame = CGRect(x: width * CGFloat(key), y: 0, width: width, height: height)
        }
    }
    
    override func viewDidLayoutSubviews() {
        print("")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCurrentPage()
        removeInvisiblePages()
        setupPages()
    }
    
    private func updateCurrentPage() {
        guard let dataSource = dataSource else {
            return
        }

        let width = canvas.frame.width
        guard width > 0 else { return }
        let x = canvas.contentOffset.x + width * 0.5
        let pageIdx = Int(x / width)
        if let chapterIdx = dataSource.getChapterIndex(pageIndex: pageIdx) {
            delegate?.render(self, switchTo: pageIdx, chapter: chapterIdx)
        }
    }
    
    private func removeInvisiblePages() {
        guard let dataSource = dataSource else {
            return
        }

        let invisiblePageIndexes = allPages.keys.filter { idx in
            return idx > dataSource.currentPageIdx + 2 || idx < dataSource.currentPageIdx - 2
        }
        
        invisiblePageIndexes.forEach { idx in
            if let pageView = allPages[idx] {
                pageView.removeFromSuperview()
            }
            allPages[idx] = nil
        }
    }
    
    private func setupPages() {
        guard let dataSource = dataSource else {
            return
        }

        let pageIndexes = [dataSource.currentPageIdx - 1, dataSource.currentPageIdx, dataSource.currentPageIdx + 1]
        for pageIndex in pageIndexes {
            let found = allPages.keys.contains(pageIndex)
            if !found {
                if let pageView = dataSource.getPageAt(index: pageIndex) {
                    let width = canvas.frame.size.width
                    let height = canvas.frame.size.height
                    pageView.frame = CGRect(x: CGFloat(pageIndex) * width, y: 0, width: width, height: height)
                    canvas.addSubview(pageView)
                    allPages[pageIndex] = pageView
                }
            }
        }
    }

}
