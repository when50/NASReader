//
//  BrightnessSetable.swift
//  NASReader
//
//  Created by oneko.c on 2022/8/2.
//

import UIKit

protocol BrightnessSetable {
    var brightnessView: DYBrightnessView { get }
    func setBrightness(_ brightness: Float)
}

extension BrightnessSetable where Self: UIViewController {
    func setBrightness(_ brightness: Float) {
        brightnessView.brightness.value = brightness
    }
}
