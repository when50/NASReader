//
//  SlideInPresentationManager.swift
//  NASReader
//
//  Created by oneko.c on 2022/8/1.
//

import Foundation

enum PresentationDirection {
    case left
    case top
    case right
    case bottom
}

class SlideInPresentationManager: NSObject {
    var direction: PresentationDirection = .left
}

extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = SlideInPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            direction: direction)
        return presentationController
    }
}
