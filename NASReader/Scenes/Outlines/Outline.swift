//
//  Outline.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/20.
//

import Foundation

final class Outline: OutlineProtocol {
    var outlineItems: [OutlineItem]
    
    init(items: [OutlineItem]) {
        outlineItems = items
    }
}
