//
//  DQHorizontalScrollRender.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/4.
//

import UIKit

class DYHorizontalScrollRender: UIViewController, DYRenderProtocol {
    
    var coverStyle = false {
        didSet {
            updatePages()
        }
    }
    var dataSource: DYRenderDataSource?
    var tapFeatureArea: (() -> Void)?
    private var showPageBlock: (() -> Void)?
    private var pageView: UIView?
    
    func scrollBackwardPage(animated: Bool = true) {
        scrollPage(animated: animated, backword: true)
    }
    
    func scrollForwardPage(animated: Bool = true) {
        scrollPage(animated: animated, backword: false)
    }
    
    private func scrollPage(animated: Bool, backword: Bool) {
        let oldPage = pageView
        showPage()
        if animated {
            var initialFrame = view.bounds.offsetBy(dx: (backword ? -1 : 1) * view.bounds.width, dy: 0)
            let finalFrame = view.bounds
            let oldInitFrame = view.bounds
            var oldFinalFrame = view.bounds.offsetBy(dx: (backword ? 1 : -1) * view.bounds.width, dy: 0)
            if coverStyle {
                if backword {
                    oldFinalFrame = view.bounds
                } else {
                    initialFrame = view.bounds
                    
                    if let oldPage = oldPage {
                        view.bringSubviewToFront(oldPage)
                    }
                }
            }
            pageView?.frame = initialFrame
            oldPage?.frame = oldInitFrame
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState) {
                self.pageView?.frame = finalFrame
                oldPage?.frame = oldFinalFrame
            } completion: { _ in
                oldPage?.removeFromSuperview()
            }
        } else {
            oldPage?.removeFromSuperview()
        }
    }
    
    private func showPage() {
        if let page = dataSource?.getCurrentPage() {
            page.frame = view.bounds
            page.backgroundColor = .yellow
            page.layer.shadowColor = UIColor.black.cgColor
            page.layer.shadowOpacity = coverStyle ? 1 : 0
            page.layer.shadowOffset = .zero
            page.layer.shadowRadius = 10
            
            view.addSubview(page)
            pageView = page
        }
    }
    
    private func updatePages() {
        view.subviews.forEach { page in
            page.layer.shadowColor = UIColor.black.cgColor
            page.layer.shadowOpacity = coverStyle ? 1 : 0
            page.layer.shadowOffset = .zero
            page.layer.shadowRadius = 10
        }
    }
    
}
