//
//  Outline.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/20.
//

import Foundation

struct Outline: OutlineProtocol {
    var items: [OutlineItem]
    
    init(items: [OutlineItem]) {
        self.items = items
    }
    
    func itemAt(index: Int) -> OutlineItem? {
        guard items.indices.contains(index) else { return nil }
        return items[index]
    }
}
