//
//  DYReaderCoordinator.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/20.
//

import UIKit

@objc
final class DYReaderCoordinator: NSObject, Coordinator, OutlineCoordinable, DYReaderCoordinatorProtocol  {
    @objc
    var navigationController: UINavigationController
    
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
    
    func showOutline(_ outline: OutlineProtocol) {
        showOutline(for: outline, navigationController: navigationController)
    }
}
