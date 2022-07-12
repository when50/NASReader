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
        var lineSpaceSpacers = [UIView]()
        var lineSpaceViews = [String: UIView]()
        var lineSpaceIdx = 0
        lineSpaceIcons.forEach { icon in
            let btn = UIButton(type: .system)
            btn.setImage(UIImage.icon(withName: icon, fontSize: 14.0, color: .black), for: .selected)
            btn.setImage(UIImage.icon(withName: icon, fontSize: 14.0, color: .gray), for: .normal)
            btn.layer.borderColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 0.2)
            lineSpaceBtns.append(btn)
            lineSpaceViews["lineSpaceBtns\(lineSpaceIdx)"] = btn
            if lineSpaceIdx + 1 < lineSpaceIcons.count {
                let spacer = UIView()
                spacer.backgroundColor = .clear
                lineSpaceSpacers.append(spacer)
                lineSpaceViews["spacer\(lineSpaceIdx)"] = spacer
            }
            lineSpaceIdx += 1
        }
        addSubviews(lineSpaceBtns)
        addSubviews(lineSpaceSpacers)
        lineSpaceBtns.forEach { btn in
            addConstraint(NSLayoutConstraint(item: btn, attribute: .centerY, relatedBy: .equal, toItem: labels[2], attribute: .centerY, multiplier: 1.0, constant: 0.0))
        }
        lineSpaceSpacers.forEach { spacer in
            addConstraint(NSLayoutConstraint(item: spacer, attribute: .centerY, relatedBy: .equal, toItem: labels[2], attribute: .centerY, multiplier: 1.0, constant: 0.0))
        }
        let lineSpaceHConstraints = "H:|-(90)-[lineSpaceBtns0]-[spacer0(spacer1)]-[lineSpaceBtns1]-[spacer1(spacer2)]-[lineSpaceBtns2]-[spacer2]-[lineSpaceBtns3]-(30)-|"
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: lineSpaceHConstraints, metrics: nil, views: lineSpaceViews))
        lineSpaceSpacers.forEach { spacer in
            addConstraint(NSLayoutConstraint(item: spacer, attribute: .height, relatedBy: .equal, toItem: lineSpaceBtns[0], attribute: .height, multiplier: 1.0, constant: 0.0))
        }
        
        // 背景
        let bgImgs = [
            bgImage(color: #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 1)),
            bgImage(color: #colorLiteral(red: 0.9529411765, green: 0.9176470588, blue: 0.8117647059, alpha: 1)),
            bgImage(color: #colorLiteral(red: 0.9254901961, green: 0.9803921569, blue: 0.9254901961, alpha: 1)),
            bgImage(color: #colorLiteral(red: 0.9725490196, green: 0.9764705882, blue: 0.9411764706, alpha: 1)),
            UIImage(named: "bookReader_icon_background5")
        ]
        var bgViews = [String: UIView]()
        var bgBtns = [UIButton]()
        var bgSpacers = [UIView]()
        var bgIdx = 0
        bgImgs.forEach { img in
            let btn = UIButton(type: .custom)
            btn.setImage(img, for: .normal)
            bgBtns.append(btn)
            bgViews["bgBtn\(bgIdx)"] = btn
            if bgIdx + 1 < bgImgs.count {
                let spacer = UIView()
                spacer.backgroundColor = .clear
                bgSpacers.append(spacer)
                bgViews["spacer\(bgIdx)"] = spacer
            }
            bgIdx += 1
        }
        addSubviews(bgBtns)
        addSubviews(bgSpacers)
        bgBtns.forEach { btn in
            addConstraint(NSLayoutConstraint(item: btn, attribute: .centerY, relatedBy: .equal, toItem: labels[3], attribute: .centerY, multiplier: 1.0, constant: 0.0))
            addConstraint(NSLayoutConstraint(item: btn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 32.0))
        }
        bgSpacers.forEach { spacer in
            addConstraint(NSLayoutConstraint(item: spacer, attribute: .centerY, relatedBy: .equal, toItem: labels[3], attribute: .centerY, multiplier: 1.0, constant: 0.0))
            addConstraint(NSLayoutConstraint(item: spacer, attribute: .height, relatedBy: .equal, toItem: bgBtns[0], attribute: .height, multiplier: 1.0, constant: 0.0))
        }
        let bgHConstraints = "H:|-(90)-[bgBtn0(48)][spacer0][bgBtn1(48)][spacer1(spacer0)][bgBtn2(48)][spacer2(spacer0)][bgBtn3(48)][spacer3(spacer0)][bgBtn4(48)]-(30)-|"
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: bgHConstraints, metrics: nil, views: bgViews))
        
        // 翻页
        let pageStyleTitles = ["覆盖", "仿真", "平移", "滚动"]
        var pageStyleViews = [String: UIView]()
        var pageBtns = [UIButton]()
        var pageSpacers = [UIView]()
        var pageIdx = 0
        pageStyleTitles.forEach { title in
            let btn = UIButton(type: .system)
            btn.setTitle(title, for: .normal)
            pageBtns.append(btn)
            pageStyleViews["pageBtn\(pageIdx)"] = btn
            if pageIdx + 1 < pageStyleTitles.count {
                let spacer = UIView()
                spacer.backgroundColor = .clear
                pageSpacers.append(spacer)
                pageStyleViews["spacer\(pageIdx)"] = spacer
            }
            pageIdx += 1
        }
        addSubviews(pageBtns)
        addSubviews(pageSpacers)
        pageBtns.forEach { btn in
            addConstraint(NSLayoutConstraint(item: btn, attribute: .centerY, relatedBy: .equal, toItem: labels[4], attribute: .centerY, multiplier: 1.0, constant: 0.0))
            addConstraint(NSLayoutConstraint(item: btn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 33.0))
        }
        pageSpacers.forEach { spacer in
            addConstraint(NSLayoutConstraint(item: spacer, attribute: .centerY, relatedBy: .equal, toItem: labels[4], attribute: .centerY, multiplier: 1.0, constant: 0.0))
            addConstraint(NSLayoutConstraint(item: spacer, attribute: .height, relatedBy: .equal, toItem: pageBtns[0], attribute: .height, multiplier: 1.0, constant: 0.0))
        }
        let pageStyleHConstraints = "H:|-(80)-[pageBtn0(48)][spacer0][pageBtn1(48)][spacer1(spacer0)][pageBtn2(48)][spacer2(spacer0)][pageBtn3(48)]-(20)-|"
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: pageStyleHConstraints, metrics: nil, views: pageStyleViews))
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
    
    private func bgImage(color: UIColor) -> UIImage {
        let image = UIImage.init(color: color, size: CGSize(width: 40.0, height: 24.0))
        return image.byRoundCornerRadius(12.0)
    }

}
