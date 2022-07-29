//
//  DNSimpleSlider.swift
//  dnovel
//
//  Created by oneko on 2021/1/9.
//  Copyright © 2021 blox. All rights reserved.
//

import UIKit

class DNSimpleSlider: UIView {
    @objc var progress: CGFloat = 0 {
         didSet {
            guard progressView != nil && thumbView != nil else { return }
            guard progress != oldValue else { return }
             let thumbX = (bounds.width - thumbSize.width) * progress
             progressView.frame = CGRect(x: 0, y: (bounds.height - railHeight) * 0.5, width: thumbX + thumbSize.width * 0.5, height: railHeight)
             thumbView.frame = CGRect(origin: CGPoint(x: thumbX, y: (bounds.height - thumbSize.height) * 0.5), size: thumbSize)
         }
     }
    @objc var dragStart: (() -> Void)?    // 开始拖拽
    @objc var dragMoved: ((CGFloat) -> Void)?   // 拖拽中，参数是拖拽到的进度
    @objc var dragEnd: ((CGFloat) -> Void)?   // 拖拽结束，参数是拖拽到的进度
    @objc var dragCanceled: (() -> Void)? // 取消拖拽
    @objc private(set) var railView: UIView!
    @objc private(set) var progressView: UIView!
    @objc private(set) var thumbView: UIView!
    @objc var progressChanged = false  // 标志是否已经变更过进度
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let thumbSize = CGSize(width: 12, height: 12)
    private let railHeight: CGFloat = 2
    private func buildUI() {
        railView = UIView(frame: CGRect(x: 0, y: (bounds.height - railHeight) * 0.5, width: bounds.width, height: railHeight))
        railView.backgroundColor = #colorLiteral(red: 0.9531050324, green: 0.9531050324, blue: 0.9531050324, alpha: 1)
        railView.layer.cornerRadius = 1
        railView.layer.masksToBounds = true
        addSubview(railView)
        
        progressView = UIView(frame: CGRect(x: 0, y: (bounds.height - railHeight) * 0.5, width: thumbSize.width * 0.5, height: railHeight))
        progressView.backgroundColor = #colorLiteral(red: 0.2605186105, green: 0.2605186105, blue: 0.2605186105, alpha: 1)
        progressView.layer.cornerRadius = 1
        progressView.layer.masksToBounds = true
        addSubview(progressView)
        
        thumbView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: (bounds.height - thumbSize.height) * 0.5), size: thumbSize))
        thumbView.backgroundColor = #colorLiteral(red: 0.2605186105, green: 0.2605186105, blue: 0.2605186105, alpha: 1)
        thumbView.layer.cornerRadius = 6
        thumbView.layer.masksToBounds = true
        addSubview(thumbView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        railView.frame = CGRect(x: 0, y: (bounds.height - railHeight) * 0.5, width: bounds.width, height: railHeight)
        let thumbX = (bounds.width - thumbSize.width) * progress
        progressView.frame = CGRect(x: 0, y: (bounds.height - railHeight) * 0.5, width: thumbX + thumbSize.width * 0.5, height: railHeight)
        thumbView.frame = CGRect(origin: CGPoint(x: thumbX, y: (bounds.height - thumbSize.height) * 0.5), size: thumbSize)
    }
    
    private var seekable = true
    private var isDraging = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if seekable {
            isDraging = true
            isMoved = false
            dragStart?()
        }
    }
    
    private var isMoved = false // 区分拖拽还是点击
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDraging else { return }
        guard let point = touches.first?.location(in: self) else { return }
        var center = thumbView.center
        center.x = max(point.x, thumbSize.width * 0.5);
        center.x = min(center.x, bounds.width - thumbSize.width * 0.5);
        thumbView.center = center
        
        var progress = thumbView.frame.minX / (bounds.width - thumbView.frame.width)
        progress = max(progress, 0)
        progress = min(progress, 1.0)
        self.progress = progress
        
        progressChanged = true
        isMoved = true
        dragMoved?(progress)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDraging else { return }
        guard let point = touches.first?.location(in: self) else { return }
        var center = thumbView.center
        center.x = max(point.x, thumbSize.width * 0.5);
        center.x = min(center.x, bounds.width - thumbSize.width * 0.5);
        thumbView.center = center
        
        var progress = thumbView.frame.minX / (bounds.width - thumbView.frame.width)
        progress = max(progress, 0)
        progress = min(progress, 1.0)
        
        progressChanged = true
        if isMoved {
            dragEnd?(self.progress)
        }
        else {
            dragEnd?(progress)
        }
        isDraging = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDraging else { return }
        dragCanceled?()
        isDraging = false
    }

}
