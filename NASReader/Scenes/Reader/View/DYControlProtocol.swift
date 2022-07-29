//
//  DYControlProtocol.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/9.
//

import UIKit

protocol DYControlProtocol {
    func addSubviews(_ subViews: [UIView])
}

extension DYControlProtocol where Self: UIView {
    func addSubviews(_ subViews: [UIView]) {
        subViews.forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subView)
        }
    }
}
