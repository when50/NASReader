//
//  DYReaderCoordinator.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/20.
//

import UIKit

@objc
final class DYReaderCoordinator: NSObject, Coordinator, OutlineCoordinable, DYReaderCoordinatorProtocol  {
    lazy var transitioningDelegate = SlideInPresentationManager()
    
    @objc
    var navigationController: UINavigationController
    private lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    @objc
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    @objc
    func start() {
        let viewController = DYReaderController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showOutline(for outline: OutlineProtocol, delegate: OutlineViewControllerDelegate, brightness: Float) {
        transitioningDelegate.direction = .left
        showOutline(for: outline,
                    delegate: delegate,
                    transitioningDelegate: transitioningDelegate,
                    brightness: brightness)
    }
}
