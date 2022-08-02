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

protocol DYRenderProtocol {
    var dataSource: DYRenderDataSource? { get set }
    func buildRender(parentController: UIViewController)
    func scrollBackwardPage(animated: Bool)
    func scrollForwardPage(animated: Bool)
    func clean()
}

extension DYRenderProtocol where Self: UIViewController {
    func buildRender(parentController: UIViewController) {
        parentController.addChild(self)
        view.frame = parentController.view.bounds
        view.translatesAutoresizingMaskIntoConstraints = false
        if let container = parentController as? DYReaderContainer {
            container.containerView.addSubview(view)
        }
        didMove(toParent: parentController)
    }
    
    func clean() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
