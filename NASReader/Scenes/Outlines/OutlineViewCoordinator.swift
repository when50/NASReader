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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = OutlineViewController()
        viewController.coordinator = self
        viewController.outline = outline
        navigationController.present(viewController, animated: true, completion: nil)
    }
}
