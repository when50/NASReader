//
//  OutlineViewCoordinator.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/20.
//

import UIKit

final class OutlineViewCoordinator: Coordinator, OutlineViewCoordinatorProtocol {
    var navigationController: UINavigationController
    var outline: OutlineProtocol?
    var delegate: OutlineViewControllerDelegate?
    var transitioningDelegate: UIViewControllerTransitioningDelegate?
    
    init(navigationController: UINavigationController, transitioningDelegate: UIViewControllerTransitioningDelegate? = nil) {
        self.navigationController = navigationController
        self.transitioningDelegate = transitioningDelegate
    }
    
    func start() {
        let viewController = OutlineViewController()
        viewController.coordinator = self
        viewController.outline = outline
        viewController.delegate = delegate
        if let transitioningDelegate = transitioningDelegate {
            viewController.transitioningDelegate = transitioningDelegate
            viewController.modalPresentationStyle = .custom
        }
        navigationController.present(viewController, animated: true, completion: nil)
    }
}
