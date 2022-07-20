//
//  OutlineCoordinable.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/20.
//

import Foundation

protocol OutlineCoordinable {
    func showOutline(for outline: OutlineProtocol, navigationController: UINavigationController)
}

extension OutlineCoordinable where Self: Coordinator {
    func showOutline(for outline: OutlineProtocol, navigationController: UINavigationController) {
        let coordinator = OutlineViewCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
