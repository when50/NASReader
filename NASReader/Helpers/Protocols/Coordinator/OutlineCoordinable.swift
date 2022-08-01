//
//  OutlineCoordinable.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/20.
//

import UIKit

protocol OutlineCoordinable {
    func showOutline(for outline: OutlineProtocol,
                     delegate: OutlineViewControllerDelegate,
                     transitioningDelegate: UIViewControllerTransitioningDelegate)
}

extension OutlineCoordinable where Self: Coordinator {
    func showOutline(for outline: OutlineProtocol,
                     delegate: OutlineViewControllerDelegate,
                     transitioningDelegate: UIViewControllerTransitioningDelegate) {
        let coordinator = OutlineViewCoordinator(navigationController: navigationController)
        coordinator.outline = outline
        coordinator.delegate = delegate
        coordinator.transitioningDelegate = transitioningDelegate
        coordinator.start()
    }
}
