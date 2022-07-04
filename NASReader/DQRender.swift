//
//  DQRender.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/2.
//

import Foundation
import UIKit

protocol DQRender {
    func buildRender(parentController: UIViewController)
    func clean()
}
