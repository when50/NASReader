//
//  DYRenderConfig.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/29.
//

import Foundation

struct DYRenderModel: Equatable {
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
    var useSystemBrightness: Bool
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
            if lineSpace != LineSpace.all[newValue] {
                lineSpace = LineSpace.all[newValue]
            }
        }
    }
    
    var backgroundColorIndex: Int {
        get {
            assert(backgroundColor.index != nil, "找不到backgroundColor：\(backgroundColor)")
            return backgroundColor.index!
        }
        set {
            assert(BackgroundColor.all.indices.contains(newValue), "无法设置backgroundColor: \(newValue)")
            if backgroundColor != BackgroundColor.all[newValue] {
                backgroundColor = BackgroundColor.all[newValue]
            }
        }
    }
    
    var styleIndex: Int {
        get {
            assert(style.index != nil, "找不到styleIndex：\(style)")
            return style.index!
        }
        set {
            assert(Style.all.indices.contains(newValue), "无法设置backgroundColor: \(newValue)")
            if style != Style.all[newValue] {
                style = Style.all[newValue]
            }
        }
    }
    
    static func modelWithDictionary(_ dictionary: [String: AnyObject]) -> DYRenderModel {
        var instance = DYRenderModel(brightness: 0.0,
                                     useSystemBrightness: true,
                                     fontSize: 18,
                                     lineSpace: .lineSpace1,
                                     backgroundColor: .color5,
                                     style: .cover)
        if let brightness = dictionary["brightness"]?.floatValue {
            instance.brightness = brightness
        }
        if let useSystemBrightness = dictionary["useSystemBrightness"]?.boolValue {
            instance.useSystemBrightness = useSystemBrightness
        }
        if let fontSize = dictionary["fontSize"]?.floatValue {
            instance.fontSize = fontSize
        }
        if let idx = dictionary["lineSpace"]?.integerValue, LineSpace.all.indices.contains(idx) {
            instance.lineSpace = LineSpace.all[idx]
        }
        if let idx = dictionary["backgroundStyle"]?.integerValue, BackgroundColor.all.indices.contains(idx) {
            instance.backgroundColor = BackgroundColor.all[idx]
        }
        if let idx = dictionary["pageStyle"]?.integerValue, Style.all.indices.contains(idx) {
            instance.style = Style.all[idx]
        }
        return instance
    }
    
    func toDictionary() -> [String: AnyObject] {
        return ["brightness": NSNumber(value: brightness),
                "useSystemBrightness": NSNumber(value: useSystemBrightness),
                "fontSize": NSNumber(value: fontSize),
                "lineSpace": NSNumber(value: lineSpaceIndex),
                "backgroundStyle": NSNumber(value: backgroundColorIndex),
                "pageStyle": NSNumber(value: styleIndex)]
    }
}
