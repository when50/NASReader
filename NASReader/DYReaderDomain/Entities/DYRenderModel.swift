//
//  DYRenderConfig.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/29.
//

import Foundation

struct DYRenderModel {
    enum LineSpace {
        case lineSpace1
        case lineSpace2
        case lineSpace3
        case lineSpace4
    }
    
    enum BackgroundColor {
        case color1
        case color2
        case color3
        case color4
        case color5
    }
    
    enum Style {
        case cover
        case curl
        case scrollHorizontal
        case scrollVertical
    }
    
    struct FontSize {
        static let range = 16.0...28.0
    }
    
    var brightness: Float
    var applyBrightness: Bool
    private(set) var fontSize: Float
    var lineSpace = LineSpace.lineSpace1
    var backgroundColor = BackgroundColor.color1
    var style = Style.cover
    
    var isMinFontSize: Bool {
        return abs(FontSize.range.lowerBound - Double(fontSize)) < 0.5
    }
    var isMaxFontSize: Bool {
        return abs(FontSize.range.upperBound - Double(fontSize)) < 0.5
    }
    
    mutating func minusFontSize() {
        if FontSize.range.contains(Double(fontSize) - 1) {
            fontSize -= 1
        }
    }
    
    mutating func increaseFontSize() {
        if FontSize.range.contains(Double(fontSize) + 1) {
            fontSize += 1
        }
    }
}
