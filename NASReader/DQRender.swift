//
//  DQRender.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/2.
//

import Foundation
import UIKit

protocol DQRender {
    func buildRender(parentController: UIViewController)
    func clean()
}

extension DQRender where Self: UIViewController {
    func buildRender(parentController: UIViewController) {
        parentController.addChild(self)
        view.frame = parentController.view.bounds
        parentController.view.addSubview(view)
        didMove(toParent: parentController)
    }
    
    func clean() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
