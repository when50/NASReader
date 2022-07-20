//
//  OutlineItem.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/20.
//

import Foundation

public struct OutlineItem {
    let title: String
    let location: Int?
    let subItems: [OutlineItem]
}
