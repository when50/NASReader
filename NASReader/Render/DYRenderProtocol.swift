//
//  DQRender.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/2.
//

import Foundation
import UIKit

protocol DYRenderDelegate {
    func switchTo(chapterIndex: Int, pageIndex: Int) -> Bool
    func switchPrevPage() -> Bool
    func switchNextPage() -> Bool
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
    var tapFeatureArea: (() -> Void)? { get set }
    var delegate: DYRenderDelegate? { get set }
    var dataSource: DYRenderDataSource? { get set }
    func buildRender(parentController: UIViewController)
    func showPage(animated: Bool)
    func clean()
}

extension DYRenderProtocol where Self: UIViewController {
    func switchTo(chapterIndex: Int, pageIndex: Int) -> Bool {
        return delegate?.switchTo(chapterIndex: chapterIndex, pageIndex: pageIndex) ?? false
    }
    
    func buildRender(parentController: UIViewController) {
        parentController.addChild(self)
        view.frame = parentController.view.bounds
        parentController.view.addSubview(view)
        parentController.view.sendSubviewToBack(view)
        didMove(toParent: parentController)
    }
    
    func clean() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
