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
    let location: Int?
    let subItems: [OutlineItem]?
    
    init(chapter: DYChapter) {
        title = chapter.title
        cached = false
        location = Int(chapter.pageIdx)
        subItems = nil
    }
}
