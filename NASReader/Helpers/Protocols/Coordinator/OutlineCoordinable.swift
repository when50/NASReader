//
//  OutlineCoordinable.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/20.
//

import Foundation

protocol OutlineCoordinable {
    func showOutline(for outline: OutlineProtocol,
                     delegate: OutlineViewControllerDelegate)
}

extension OutlineCoordinable where Self: Coordinator {
    func showOutline(for outline: OutlineProtocol,
                     delegate: OutlineViewControllerDelegate) {
        let coordinator = OutlineViewCoordinator(navigationController: navigationController)
        coordinator.outline = outline
        coordinator.delegate = delegate
        coordinator.start()
    }
}
