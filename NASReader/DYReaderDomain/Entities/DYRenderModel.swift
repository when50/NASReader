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
        
        static var all: [LineSpace] {
            return [.lineSpace1, .lineSpace2, .lineSpace3, .lineSpace4]
        }
        
        var index: Int? {
            return LineSpace.all.firstIndex(of: self)
        }
    }
    
    enum BackgroundColor {
        case color1
        case color2
        case color3
        case color4
        case color5
        
        static var all: [BackgroundColor] {
            return [.color1, .color2, .color3, .color4, .color5]
        }
        var index: Int? {
            return BackgroundColor.all.firstIndex(of: self)
        }
    }
    
    enum Style {
        case cover
        case curl
        case scrollHorizontal
        case scrollVertical
        
        static var all: [Style] {
            return [.cover, .curl, .scrollHorizontal, .scrollVertical]
        }
        var index: Int? {
            return Style.all.firstIndex(of: self)
        }
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
    
    var lineSpaceIndex: Int {
        get {
            assert(lineSpace.index != nil, "找不到lineSpace：\(lineSpace)")
            return lineSpace.index!
        }
        set {
            assert(LineSpace.all.indices.contains(newValue), "无法设置lineSpace: \(newValue)")
            lineSpace = LineSpace.all[newValue]
        }
    }
    
    var backgroundColorIndex: Int {
        get {
            assert(backgroundColor.index != nil, "找不到backgroundColor：\(backgroundColor)")
            return backgroundColor.index!
        }
        set {
            assert(BackgroundColor.all.indices.contains(newValue), "无法设置backgroundColor: \(newValue)")
            backgroundColor = BackgroundColor.all[newValue]
        }
    }
    
    var styleIndex: Int {
        get {
            assert(style.index != nil, "找不到styleIndex：\(style)")
            return style.index!
        }
        set {
            assert(Style.all.indices.contains(newValue), "无法设置backgroundColor: \(newValue)")
            style = Style.all[newValue]
        }
    }
}
