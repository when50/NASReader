//
//  Coordinator.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/20.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
}
