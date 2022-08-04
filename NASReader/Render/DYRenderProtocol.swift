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
}

protocol DYRenderProtocol: AnyObject {
    var delegate: DYRenderDelegate? { get set }
    var dataSource: DYRenderDataSource? { get set }
    func supportStyle(style: DYRenderModel.Style) -> Bool
    func buildRender(parentController: UIViewController)
    func scrollBackwardPage(animated: Bool)
    func scrollForwardPage(animated: Bool)
    func clean()
    func processTapAt(location: Float)
}

struct DYRenderConstant {
    static let scrollTapRange: Float = 0.3
}

extension DYRenderProtocol where Self: UIViewController {
    func buildRender(parentController: UIViewController) {
        if let delegate = parentController as? DYRenderDelegate {
            self.delegate = delegate
        }
        parentController.addChild(self)
        view.translatesAutoresizingMaskIntoConstraints = false
        if let container = parentController as? DYReaderContainer {
            container.containerView.addSubview(view)
            NSLayoutConstraint.activate(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                               metrics: nil,
                                               views: ["view": view]))
            NSLayoutConstraint.activate(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                               metrics: nil,
                                               views: ["view": view]))
        }
        didMove(toParent: parentController)
    }
    
    func clean() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func processTapAt(location: Float) {
        switch location {
        case let v where v < DYRenderConstant.scrollTapRange:
            print("scroll backward")
            delegate?.render(self, didTap: .scrollBackword)
        case let v where v + DYRenderConstant.scrollTapRange > 1.0:
            print("scroll forward")
            delegate?.render(self, didTap: .scrollForward)
        default:
            print("toggle control")
            delegate?.render(self, didTap: .toggleNavigationFeautre)
        }
    }
}
