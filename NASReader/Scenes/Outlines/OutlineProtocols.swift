//
//  OutlineProtocols.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/20.
//

import Foundation

protocol OutlineProtocol {
    var items: [OutlineItem] { get }
    
    func itemAt(index: Int) -> OutlineItem!
}

protocol OutlineViewCoordinatorProtocol: AnyObject {
    
}
