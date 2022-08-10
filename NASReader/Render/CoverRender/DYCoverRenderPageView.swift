//
//  DYCoverRenderPageView.swift
//  NASReader
//
//  Created by oneko.c on 2022/8/10.
//

import UIKit

class DYCoverRenderPageView: UIView {
    private let backgroundView = DNReaderBackgroundView(frame: .zero)
    var backgroundConfig: AnyObject? {
        didSet {
            if let config = backgroundConfig {
                backgroundView.update(config: config)
            }
        }
    }

    var pageView: UIView? {
        didSet {
            if let pageView = pageView {
                addSubview(pageView)
                setNeedsLayout()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = bounds
        if #available(iOS 11.0, *) {
            pageView?.frame = bounds.inset(by: safeAreaInsets)
        } else {
            pageView?.frame = bounds
        }
    }

}
