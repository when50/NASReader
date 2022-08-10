//
//  DYCurlRenderViewController.swift
//  NASReader
//
//  Created by oneko.c on 2022/8/8.
//

import UIKit

class DYCurlRenderViewController: UIPageViewController, DYBackgroundRenderProtocol, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var backgroundConfig: AnyObject?
    
    weak var renderDelegate: DYRenderDelegate?
    var renderDataSource: DYRenderDataSource? {
        didSet {
            if let pageIdx = renderDataSource?.currentPageIdx {
                setViewControllers([buildPageViewController(at: pageIdx)],
                                   direction: .forward,
                                   animated: false,
                                   completion: nil)
            }
        }
    }
    
    func supportStyle(style: DYRenderModel.Style) -> Bool {
        return style == .curl
    }
    
    func scrollToCurrentPage(animated: Bool) {
        if let pageIdx = renderDataSource?.currentPageIdx {
            setViewControllers([buildPageViewController(at: pageIdx)],
                               direction: .forward,
                               animated: animated,
                               completion: nil)
        }
    }
    
    func buildRender(parentController: UIViewController) {
        if let delegate = parentController as? DYRenderDelegate {
            self.renderDelegate = delegate
        }
        parentController.addChild(self)
        view.translatesAutoresizingMaskIntoConstraints = false
        if let container = parentController as? DYReaderContainer,
            let parentView = container.containerView.superview {
            container.containerView.addSubview(view)
            view.frame = container.containerView.bounds
            let attributes = [NSLayoutConstraint.Attribute.top, .leading, .bottom, .trailing]
            NSLayoutConstraint.activate(attributes.map({ attribute in
                return NSLayoutConstraint(item: parentView, attribute: attribute, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1.0, constant: 0.0)
            }))
        }
        didMove(toParent: parentController)
    }
    
    func cleanCache() {
        if let pageIdx = renderDataSource?.currentPageIdx {
            setViewControllers([buildPageViewController(at: pageIdx)],
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = self
        delegate = self
        
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
    
    private func buildPageViewController(at index: Int) -> UIViewController {
        let vc = DYPageViewController(nibName: nil, bundle: nil)
        vc.pageIdx = index
        if let config = backgroundConfig {
            vc.backgroundView.update(config: config)
        }
        if let pageView = renderDataSource?.getPageAt(index: index) {
            vc.pageView = pageView
        }
        return vc
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageIdx = self.renderDataSource?.currentPageIdx, pageIdx > 0 else { return nil }
        return buildPageViewController(at: pageIdx - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageIdx = self.renderDataSource?.currentPageIdx, let pageNum = self.renderDataSource?.pageNum, pageIdx + 1 < pageNum else { return nil }
        return buildPageViewController(at: pageIdx + 1)
    }
    
    // MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let pageVCs = pageViewController.viewControllers as? [DYPageViewController],
                let pageNum = renderDataSource?.pageNum,
                pageNum > 0 else { return }
        if let pageIdx = pageVCs.first?.pageIdx, let chapterIdx = self.renderDataSource?.getChapterIndex(pageIndex: pageIdx) {
            self.renderDelegate?.render(self, switchTo: pageIdx, chapter: chapterIdx)
        }
    }
}
