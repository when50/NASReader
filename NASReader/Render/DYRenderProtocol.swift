//
//  DQRender.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/2.
//

import Foundation
import UIKit

protocol DYRenderProtocol {
    var currentPage: Int { get set }
    var pageNum: Int { get set }
    var pageSize: CGSize { get set }
    var pageMaker: ((Int) -> UIView?)? { get set }
    var tapFeatureArea: (() -> Void)? { get set }
    func buildRender(parentController: UIViewController)
    func showPageAt(_ pageIdx: Int, animated: Bool)
    func clean()
}

extension DYRenderProtocol where Self: UIViewController {
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
