//
//  DYReaderNavigationView.swift
//  NASReader
//
//  Created by oneko on 2022/7/8.
//

import UIKit

class DYReaderNavigationView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        backgroundColor = .white
        
        let backBtn = UIButton(type: .system)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.setImage(UIImage.icon(withName: "图标-返回", fontSize: 17.6, color: .black), for: .normal)
        addSubview(backBtn)
        addConstraint(NSLayoutConstraint(item: backBtn, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 20))
        addConstraint(NSLayoutConstraint(item: backBtn, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -7))
    }

}
