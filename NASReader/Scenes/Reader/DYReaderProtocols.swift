//
//  DYReaderProtocols.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/20.
//

import UIKit

protocol DYReaderCoordinatorProtocol: AnyObject {
    func showOutline(for outline: OutlineProtocol,
                     delegate: OutlineViewControllerDelegate,
                     brightness: Float)
}
