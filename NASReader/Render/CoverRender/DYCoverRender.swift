//
//  DQHorizontalScrollRender.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/4.
//

import UIKit

class DYCoverRender: UIViewController, DYRenderProtocol, UIScrollViewDelegate {
    
    var renderDelegate: DYRenderDelegate?
    var renderDataSource: DYRenderDataSource?
    private var canvas: UIScrollView!
    private var allPages: [Int: UIView] = [:]
    
    override func loadView() {
        let view = UIView()
        
        canvas = UIScrollView()
        canvas.isPagingEnabled = true
        canvas.delegate = self
        canvas.showsVerticalScrollIndicator = false
        canvas.showsHorizontalScrollIndicator = false
        view.addSubview(canvas)
        
        self.view = view
    }
    
    func cleanCache() {
        allPages.forEach { (key: Int, value: UIView) in
            value.removeFromSuperview()
        }
        allPages.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
    }
    
    override func viewWillLayoutSubviews() {
        canvas.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollViewDidScroll(canvas)
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
    
    func supportStyle(style: DYRenderModel.Style) -> Bool {
        return style == .cover
    }
    
    func scrollBackwardPage(animated: Bool = true) {
//        scrollPage(animated: animated, backword: true)
    }
    
    func scrollForwardPage(animated: Bool = true) {
//        scrollPage(animated: animated, backword: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = canvas.frame.size.width
        let height = canvas.frame.size.height
        
        canvas.contentInset = .zero
        canvas.contentSize = CGSize(width: width * CGFloat(renderDataSource?.pageNum ?? 0), height: height)
        canvas.contentOffset = CGPoint(x: width * CGFloat(renderDataSource?.currentPageIdx ?? 0), y: 0)
        
        allPages.forEach { (key: Int, value: UIView) in
            value.frame = CGRect(x: width * CGFloat(key), y: 0, width: width, height: height)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCurrentPage()
        removeInvisiblePages()
        setupPages()
    }
    
    private func updateCurrentPage() {
        guard let dataSource = renderDataSource else {
            return
        }

        let width = canvas.frame.width
        guard width > 0 else { return }
        let x = canvas.contentOffset.x + width * 0.5
        let pageIdx = Int(x / width)
        if let chapterIdx = dataSource.getChapterIndex(pageIndex: pageIdx) {
            renderDelegate?.render(self, switchTo: pageIdx, chapter: chapterIdx)
        }
    }
    
    private func removeInvisiblePages() {
        guard let dataSource = renderDataSource else {
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
        guard let dataSource = renderDataSource else {
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
