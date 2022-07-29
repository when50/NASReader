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
    
    var brightness: Float
    var applyBrightness: Bool
    var fontSize: Float
    var lineSpace = LineSpace.lineSpace1
    var backgroundColor = BackgroundColor.color1
    var style = Style.cover
    
    
}
