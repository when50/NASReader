//
//  DYReaderSettingView.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/9.
//

import UIKit

class DYReaderSettingView: UIView, DYControlProtocol {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        var labels = [UILabel]()
        let labelTitles = ["亮度", "字号", "间距", "背景", "翻页"]
        let spaceY: CGFloat = 60.0
        var top: CGFloat = 20.0
        
        labelTitles.forEach { title in
            labels.append(setupTitleLabel(title: title, top: top))
            top = top + spaceY
        }
        
        // 亮度
        let highLightImageView = UIImageView(image: UIImage.icon(withName: "图标-亮度+", fontSize: 17.4, color: .black))
        let lowLightImageView = UIImageView(image: UIImage.icon(withName: "图标-亮度-", fontSize: 17.4, color: .black))
        let lightSlider = UISlider(frame: .zero)
        let systemLightBtn = UIButton(type: .system)
        
        let unselectedImg1 = UIImage.icon(withName: "图标-未选择", fontSize: 14.0, color: .black)
        let selectedImg2 = UIImage.icon(withName: "图标-已选择", fontSize: 14.0, color: .black)
        systemLightBtn.setImage(unselectedImg1, for: .normal)
        systemLightBtn.setImage(selectedImg2, for: .selected)
        systemLightBtn.setTitle("系统", for: .normal)
        systemLightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        systemLightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        systemLightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -4)
        addSubviews([highLightImageView, lowLightImageView, lightSlider, systemLightBtn])
        
        let lightViews: [String: Any] = [
            "highLightImageView": highLightImageView,
            "lowLightImageView": lowLightImageView,
            "lightSlider": lightSlider,
            "systemLightBtn": systemLightBtn,
        ]
        addConstraint(NSLayoutConstraint(item: highLightImageView, attribute: .centerY, relatedBy: .equal, toItem: labels[0], attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: lowLightImageView, attribute: .centerY, relatedBy: .equal, toItem: labels[0], attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: lightSlider, attribute: .centerY, relatedBy: .equal, toItem: labels[0], attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: systemLightBtn, attribute: .centerY, relatedBy: .equal, toItem: labels[0], attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(80)-[highLightImageView]-[lightSlider]-[lowLightImageView]-(22)-[systemLightBtn]-(20)-|", metrics: nil, views: lightViews))
        
        // 字号
        let smallerFontBtn = UIButton(type: .system)
        smallerFontBtn.setImage(UIImage.icon(withName: "图标-减号", fontSize: 10.0, color: .black), for: .normal)
        let biggerFontBtn = UIButton(type: .system)
        biggerFontBtn.setImage(UIImage.icon(withName: "图标-加号", fontSize: 10.0, color: .black), for: .normal)
        let fontSizeLabel = UILabel()
        fontSizeLabel.font = UIFont.systemFont(ofSize: 15)
        fontSizeLabel.textColor = .black
        fontSizeLabel.textAlignment = .center
        fontSizeLabel.text = "20"
        addSubviews([smallerFontBtn, biggerFontBtn, fontSizeLabel])
        
        let fontViews = [
            "smallerFontBtn": smallerFontBtn,
            "biggerFontBtn": biggerFontBtn,
            "fontSizeLabel": fontSizeLabel
        ]
        fontSizeLabel.setContentHuggingPriority(UILayoutPriority(10), for: .horizontal)
        addConstraint(NSLayoutConstraint(item: smallerFontBtn, attribute: .centerY, relatedBy: .equal, toItem: labels[1], attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: biggerFontBtn, attribute: .centerY, relatedBy: .equal, toItem: labels[1], attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: fontSizeLabel, attribute: .centerY, relatedBy: .equal, toItem: labels[1], attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(80)-[smallerFontBtn]-[fontSizeLabel]-[biggerFontBtn]-(20)-|", metrics: nil, views: fontViews))
        
        // 间距
        let lineSpaceIcons = ["图标-行间距4", "图标-行间距3", "图标-行间距2", "图标-行间距1"]
        var lineSpaceBtns = [UIButton]()
        lineSpaceIcons.forEach { icon in
            let btn = UIButton(type: .system)
            btn.setImage(UIImage.icon(withName: icon, fontSize: 14.0, color: .black), for: .selected)
            btn.setImage(UIImage.icon(withName: icon, fontSize: 14.0, color: .gray), for: .normal)
            btn.layer.borderColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 0.2)
            lineSpaceBtns.append(btn)
        }
        addSubviews(lineSpaceBtns)
        lineSpaceBtns.forEach { btn in
            addConstraint(NSLayoutConstraint(item: btn, attribute: .centerY, relatedBy: .equal, toItem: labels[2], attribute: .centerY, multiplier: 1.0, constant: 0.0))
        }
        let lineSpaceViews = [
            "lineSpaceBtns0": lineSpaceBtns[0],
            "lineSpaceBtns1": lineSpaceBtns[1],
            "lineSpaceBtns2": lineSpaceBtns[2],
            "lineSpaceBtns3": lineSpaceBtns[3],
        ]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(90)-[lineSpaceBtns0]->=0-[lineSpaceBtns1]->=0-[lineSpaceBtns2]->=0-[lineSpaceBtns3]-(30)-|", metrics: nil, views: lineSpaceViews))
        // 背景
        // 翻页
        
    }
    
    private func setupTitleLabel(title: String, top: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 15.0)
        
        addSubviews([label])
        
        addConstraint(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: top))
        addConstraint(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 20))
            
        return label
    }

}
