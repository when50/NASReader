//
//  DQRender.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/2.
//

import Foundation
import UIKit

protocol DYReaderContainer {
    var containerView: UIView { get }
}

protocol DYRenderDataSource {
    var currentPageIdx: Int { get }
    var currentChapterIdx: Int { get }
    var pageNum: Int { get }
    var pageSize: CGSize { get }
    func getPageAt(index: Int) -> UIView?
    func getCurrentPage() -> UIView?
    func getChapterIndex(pageIndex: Int) -> Int?
}

enum DYGestureViewOperation {
    case scrollBackword
    case scrollForward
    case toggleNavigationFeautre
}

protocol DYRenderDelegate: AnyObject {
    func render(_ render: DYRenderProtocol, didTap operation: DYGestureViewOperation)
    func render(_ render: DYRenderProtocol, switchTo page: Int, chapter: Int)
}

protocol DYRenderProtocol: AnyObject {
    var renderDelegate: DYRenderDelegate? { get set }
    var renderDataSource: DYRenderDataSource? { get set }
    func supportStyle(style: DYRenderModel.Style) -> Bool
    func buildRender(parentController: UIViewController)
    func scrollBackwardPage(animated: Bool)
    func scrollForwardPage(animated: Bool)
    func cleanCache()
    func doRelease()
    func processTapAt(location: Float)
}

protocol DYBackgroundRenderProtocol: DYRenderProtocol {
    var backgroundConfig: AnyObject? { get set }
    func updateBackground(_ config: AnyObject)
}

extension DYBackgroundRenderProtocol where Self: UIPageViewController {
    func updateBackground(_ config: AnyObject) {
        backgroundConfig = config
        (viewControllers as? [DYPageViewController])?.forEach({ pageViewController in
            pageViewController.backgroundView.update(config: config)
        })
    }
}

struct DYRenderConstant {
    static let scrollTapRange: Float = 0.3
}

extension DYRenderProtocol where Self: UIViewController {
    func buildRender(parentController: UIViewController) {
        if let delegate = parentController as? DYRenderDelegate {
            self.renderDelegate = delegate
        }
        parentController.addChild(self)
        view.translatesAutoresizingMaskIntoConstraints = false
        if let container = parentController as? DYReaderContainer {
            container.containerView.addSubview(view)
            view.frame = container.containerView.bounds
            NSLayoutConstraint.activate(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                               metrics: nil,
                                               views: ["view": view!]))
            NSLayoutConstraint.activate(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                               metrics: nil,
                                               views: ["view": view!]))
        }
        didMove(toParent: parentController)
    }
    
    func doRelease() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func processTapAt(location: Float) {
        switch location {
        case let v where v < DYRenderConstant.scrollTapRange:
            print("scroll backward")
            renderDelegate?.render(self, didTap: .scrollBackword)
        case let v where v + DYRenderConstant.scrollTapRange > 1.0:
            print("scroll forward")
            renderDelegate?.render(self, didTap: .scrollForward)
        default:
            print("toggle control")
            renderDelegate?.render(self, didTap: .toggleNavigationFeautre)
        }
    }
    
    func cleanCache() {
        
    }
}
