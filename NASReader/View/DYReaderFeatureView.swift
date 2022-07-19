//
//  DYReaderFeatureView.swift
//  NASReader
//
//  Created by oneko on 2022/7/8.
//

import UIKit



protocol DYReaderFeatureViewDelegate: NSObject {
    func switchToPrevChapter()
    func switchToNextChapter()
    func switchToChapterWithProgress(_ progress: Float)
    func showOutlineViews()
    func toggleDeepColor(open: Bool)
    func toggleSettingView(shown: Bool)
}

class DYReaderFeatureView: UIView {
    weak var delegate: DYReaderFeatureViewDelegate?
    
    let previousChapterBtn = UIButton(type: .system)
    let nextChapterBtn = UIButton(type: .system)
    let progressSlider = DNSimpleSlider()
    let outlineBtn = UIButton(type: .system)
    let deepColorBtn = UIButton(type: .system)
    let settingBtn = UIButton(type: .system)
    
    var deepColorIsOpen = Bindable(false)
    var settingShown = Bindable(false)
    
    func setupBindables () {
        deepColorIsOpen.bind { [weak deepColorBtn, weak delegate] isOpen in
            deepColorBtn?.isSelected = isOpen
            delegate?.toggleDeepColor(open: isOpen)
        }
        settingShown.bind { [weak settingBtn, weak delegate] shown in
            settingBtn?.isSelected = shown
            delegate?.toggleSettingView(shown: shown)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        previousChapterBtn.setTitle("上一章", for: .normal)
        previousChapterBtn.translatesAutoresizingMaskIntoConstraints = false
        previousChapterBtn.addTarget(self, action: #selector(btnHandler(sender:)), for: .touchUpInside)
        addSubview(previousChapterBtn)
        nextChapterBtn.setTitle("下一章", for: .normal)
        nextChapterBtn.translatesAutoresizingMaskIntoConstraints = false
        nextChapterBtn.addTarget(self, action: #selector(btnHandler(sender:)), for: .touchUpInside)
        addSubview(nextChapterBtn)
        
        progressSlider.translatesAutoresizingMaskIntoConstraints = false
        progressSlider.dragEnd = { [weak delegate] progress in
            delegate?.switchToChapterWithProgress(Float(progress))
        }
        addSubview(progressSlider)
        
        let lineView = UIView()
        lineView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineView)
        
        outlineBtn.translatesAutoresizingMaskIntoConstraints = false
        outlineBtn.setImage(UIImage.icon(withName: "图标-目录", fontSize: 18.0, color: .black), for: .normal)
        outlineBtn.setTitle("目录", for: .normal)
        outlineBtn.titleLabel?.font = UIFont.systemFont(ofSize: 8.0)
        outlineBtn.addTarget(self, action: #selector(btnHandler(sender:)), for: .touchUpInside)
        outlineBtn.alignVertical(spacing: 6.0)
        addSubview(outlineBtn)
        deepColorBtn.translatesAutoresizingMaskIntoConstraints = false
        deepColorBtn.setImage(UIImage.icon(withName: "图标-夜间模式", fontSize: 18.0, color: .black), for: .normal)
        deepColorBtn.setTitle("夜间模式", for: .normal)
        deepColorBtn.titleLabel?.font = UIFont.systemFont(ofSize: 8.0)
        deepColorBtn.setImage(UIImage.icon(withName: "图标-亮度+", fontSize: 18.0, color: .black), for: .selected)
        deepColorBtn.setTitle("白天模式", for: .selected)
        deepColorBtn.addTarget(self, action: #selector(btnHandler(sender:)), for: .touchUpInside)
        deepColorBtn.alignVertical(spacing: 6.0)
        addSubview(deepColorBtn)
        settingBtn.translatesAutoresizingMaskIntoConstraints = false
        settingBtn.setImage(UIImage.icon(withName: "图标-设置", fontSize: 18.0, color: .black), for: .normal)
        settingBtn.setTitle("设置", for: .normal)
        settingBtn.titleLabel?.font = UIFont.systemFont(ofSize: 8.0)
        settingBtn.addTarget(self, action: #selector(btnHandler(sender:)), for: .touchUpInside)
        settingBtn.alignVertical(spacing: 6.0)
        addSubview(settingBtn)
        
        let views: [String: Any] = [
            "previousChapterBtn": previousChapterBtn,
            "nextChapterBtn": nextChapterBtn,
            "progressSlider": progressSlider,
            "lineView": lineView,
            "outlineBtn": outlineBtn,
            "deepColorBtn": deepColorBtn,
            "settingBtn": settingBtn,
        ]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(19)-[progressSlider(==40)]", metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[previousChapterBtn]-(15)-[progressSlider]-(15)-[nextChapterBtn]-(20)-|", metrics: nil, views: views))
        addConstraint(NSLayoutConstraint(item: previousChapterBtn, attribute: .centerY, relatedBy: .equal, toItem: progressSlider, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: nextChapterBtn, attribute: .centerY, relatedBy: .equal, toItem: progressSlider, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(78)-[lineView(==1)]", metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[lineView]-(0)-|", metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(89)-[outlineBtn(40)]", metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(40)-[outlineBtn(40)]->=0-[deepColorBtn(40)]->=0-[settingBtn(40)]-(40)-|", metrics: nil, views: views))
        addConstraint(NSLayoutConstraint(item: deepColorBtn, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: deepColorBtn, attribute: .centerY, relatedBy: .equal, toItem: outlineBtn, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: deepColorBtn, attribute: .height, relatedBy: .equal, toItem: outlineBtn, attribute: .height, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: settingBtn, attribute: .centerY, relatedBy: .equal, toItem: outlineBtn, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: settingBtn, attribute: .height, relatedBy: .equal, toItem: outlineBtn, attribute: .height, multiplier: 1.0, constant: 0))
    }
    
    @objc
    private func btnHandler(sender: UIButton) {
        switch sender {
        case previousChapterBtn:
            delegate?.switchToPrevChapter()
        case nextChapterBtn:
            delegate?.switchToNextChapter()
        case outlineBtn:
            delegate?.showOutlineViews()
        case deepColorBtn:
            deepColorIsOpen.value = !deepColorIsOpen.value
        case settingBtn:
            settingShown.value = !settingShown.value
        default:
            print("未实现的按钮点击回调")
        }
    }

}
