//
//  DYBrightnessView.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/29.
//

import UIKit

class DYBrightnessView: UIView {
    var brightness = Bindable(Float(0))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupBindables()
        brightness.value = 0
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .black.withAlphaComponent(0.55)
    }
    
    private func setupBindables() {
        brightness.bind { [weak self] value in
            self?.alpha = CGFloat(1.0 - value)
        }
    }

}
