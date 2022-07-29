//
//  OutlineItem.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/20.
//

import Foundation

public struct OutlineItem {
    let title: String
    var cached: Bool
    var isCurrent: Bool
    let location: Int?
    let subItems: [OutlineItem]?
    let identifier: Int
    
    init(chapter: DYChapter, cached: Bool, isCurrent: Bool) {
        title = chapter.title
        self.cached = cached
        self.isCurrent = isCurrent
        location = Int(chapter.pageIdx)
        subItems = nil
        identifier = OutlineItem.generateIdentifier()
    }
    
    static private var identifiderFactory = 0
    static private func generateIdentifier() -> Int {
        let identifier = identifiderFactory
        identifiderFactory += 1
        return identifier
    }
}
