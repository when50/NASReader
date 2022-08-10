//
//  DQHorizontalScrollRender.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/4.
//

import UIKit

class DYCoverRender: UIViewController, DYFullScreenRenderProtocol, UIScrollViewDelegate {
    var backgroundConfig: AnyObject?
    func updateBackground(_ config: AnyObject) {
        backgroundConfig = config
        allPages.forEach { (key: Int, value: UIView) in
            if let renderPageView = value as? DYCoverRenderPageView {
                renderPageView.backgroundConfig = backgroundConfig
            }
        }
    }
    
    weak var renderDelegate: DYRenderDelegate?
    var renderDataSource: DYRenderDataSource?
    private var canvas: UIScrollView!
    private var staticCanvas: UIView!
    private var allPages: [Int: UIView] = [:]
    
    override func loadView() {
        let view = UIView()
        
        staticCanvas = UIView(frame: .zero)
        staticCanvas.translatesAutoresizingMaskIntoConstraints = false
        staticCanvas.isUserInteractionEnabled = false
        view.addSubview(staticCanvas)
        
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
        staticCanvas.frame = view.bounds
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
    
    func scrollToCurrentPage(animated: Bool = true) {
        guard let dataSource = renderDataSource else { return }
        let width = canvas.frame.width
        let offset = CGPoint(x: dataSource.currentPageIdx * Int(width), y: 0)
        fromPageIdx = dataSource.currentPageIdx
        canvas.setContentOffset(offset, animated: animated)
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let dataSource = renderDataSource else { return }
        if fromPageIdx == nil {
            fromPageIdx = dataSource.currentPageIdx
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        fromPageIdx = nil
        setupPages()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCurrentPage()
        removeInvisiblePages()
        setupPages()
        updateStaticCanvas()
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
        
        let width = canvas.frame.size.width
        let height = canvas.frame.size.height
        
        for pageIndex in pageIndexes {
            let found = allPages.keys.contains(pageIndex)
            if !found {
                if let pageView = dataSource.getPageAt(index: pageIndex) {
                    let renderPageView = DYCoverRenderPageView(frame: CGRect(x: CGFloat(pageIndex) * width, y: 0, width: width, height: height))
                    renderPageView.backgroundConfig = backgroundConfig
                    renderPageView.pageView = pageView
                    canvas.addSubview(renderPageView)
                    allPages[pageIndex] = renderPageView
                }
            }
            
            if let renderPageView = allPages[pageIndex] {
                canvas.addSubview(renderPageView)
                renderPageView.frame = CGRect(x: CGFloat(pageIndex) * width, y: 0, width: width, height: height)
            }
        }
    }
    
    private var fromPageIdx: Int?
    private func updateStaticCanvas() {
        if let from = fromPageIdx {
            let width = canvas.frame.width
            guard width > 0 else { return }
            var to = from
            if canvas.contentOffset.x < (CGFloat(from) * width) {
                to = from - 1
            } else if canvas.contentOffset.x > (CGFloat(from) * width) {
                to = from + 1
            }
            
            guard let fromPage = allPages[from], let toPage = allPages[to] else { return }
            print("from: \(from) to: \(to)")
            
            if to > from {
                staticCanvas.addSubview(toPage)
                toPage.frame = staticCanvas.bounds
            }
            else if to < from {
                staticCanvas.addSubview(fromPage)
                fromPage.frame = staticCanvas.bounds
            }
        }
    }
    
}
