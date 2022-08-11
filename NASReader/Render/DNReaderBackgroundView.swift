//
//  DNReaderBackgroundView.swift
//  dnovel
//
//  Created by oneko on 2020/9/15.
//  Copyright © 2020 blox. All rights reserved.
//

import UIKit

class DNReaderBackgroundView: UIView {
    private var imageView: UIImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame);
        setup();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = UIColor.white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    @objc
    func update(config: AnyObject) {
        if let color = config as? UIColor {
            backgroundColor = color
            imageView.isHidden = true
        }
        else if let image = config as? UIImage {
            imageView.image = image
            imageView.isHidden = false
        }
    }

}
