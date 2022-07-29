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
    
    func itemAt(index: Int) -> OutlineItem! {
        assert(index < items.count && index >= 0, "找不到OutlineItem: \(index)")
        return items[index]
    }
}
