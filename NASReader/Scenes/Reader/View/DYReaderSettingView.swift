//
//  DYReaderSettingView.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/9.
//

import UIKit

protocol DYReaderSettingViewDelegate: AnyObject {
    func settingView(_ view: DYReaderSettingView, didChanged renderModel: DYRenderModel)
}

final class DYReaderSettingView: UIView, DYControlProtocol {
    private var renderModel = Bindable(DYRenderModel(brightness: 1.0, useSystemBrightness: true, fontSize: 12))
    func updateRenderModel(_ renderModel: DYRenderModel) {
        self.renderModel.value = renderModel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupBindables()
    }
    
    private func setupBindables() {
        renderModel.bind { [weak self] value in
            self?.brightnessSlider.value = value.brightness
            
            let brightnessIconStr = value.useSystemBrightness ? "图标-已选择" : "图标-未选择"
            self?.useSystemBrightnessBtn.setImage(UIImage.icon(withName: brightnessIconStr, fontSize: 14.0, color: .black), for: .normal)
            
            if let sself = self {
                sself.delegate?.settingView(sself, didChanged: value)
            }
            
            self?.fontSizeLabel.text = "\(Int(value.fontSize))"
            self?.smallerFontBtn.isEnabled = !value.isMinFontSize
            self?.biggerFontBtn.isEnabled = !value.isMaxFontSize
            
            self?.lineSpaceBtns.forEach({ btn in
                btn.updateBorder(shown: false)
            })
            self?.lineSpaceBtns[value.lineSpaceIndex].updateBorder(shown: true)
            self?.backgroundColorBtns.forEach({ btn in
                btn.updateBorder(shown: false)
            })
            self?.backgroundColorBtns[value.backgroundColorIndex].updateBorder(shown: true)
            self?.styleBtns.forEach({ btn in
                btn.updateBorder(shown: false)
            })
            self?.styleBtns[value.styleIndex].updateBorder(shown: true)
        }
    }
    
    let topShadowView = UIView()
    weak var delegate: DYReaderSettingViewDelegate?
    private lazy var smallerFontBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage.icon(withName: "图标-减号", fontSize: 10.0, color: .black), for: .normal)
        btn.setupBorder(cornerRadius: 12)
        btn.addTarget(self, action: #selector(fontSizeHandler(sender:)), for: .touchUpInside)
        return btn
    }()
    private lazy var biggerFontBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage.icon(withName: "图标-加号", fontSize: 10.0, color: .black), for: .normal)
        btn.setupBorder(cornerRadius: 12)
        btn.addTarget(self, action: #selector(fontSizeHandler(sender:)), for: .touchUpInside)
        return btn
    }()
    private lazy var fontSizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "20"
        return label
    }()
    
    private lazy var brightnessSlider: UISlider = {
        let brightnessSlider = UISlider(frame: .zero)
        brightnessSlider.addTarget(self, action: #selector(brightnessChanged(sender:)), for: .valueChanged)
        return brightnessSlider
    }()
    private lazy var useSystemBrightnessBtn: UIButton = {
        let btn = UIButton(type: .system)
        
        let img = UIImage.icon(withName: "图标-未选择", fontSize: 14.0, color: .black)
        btn.setImage(img, for: .normal)
        btn.setTitle("系统", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -4)
        btn.addTarget(self, action: #selector(brightnessHandler(sender:)), for: .touchUpInside)
        return btn
    }()
    private lazy var lineSpaceBtns: [UIButton] = {
        let lineSpaceIcons = ["图标-行间距4", "图标-行间距3", "图标-行间距2", "图标-行间距1"]
        return lineSpaceIcons.map { icon in
            let btn = UIButton(type: .system)
            btn.setImage(UIImage.icon(withName: icon, fontSize: 14.0, color: .black), for: .selected)
            btn.setImage(UIImage.icon(withName: icon, fontSize: 14.0, color: .gray), for: .normal)
            btn.setupBorder(cornerRadius: 10)
            btn.addTarget(self, action: #selector(lineSpaceHandler(sender:)), for: .touchUpInside)
            return btn
        }
    }()
    private lazy var backgroundColorBtns: [UIButton] = {
        let backgroundColors = [#colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.9176470588, blue: 0.8117647059, alpha: 1), #colorLiteral(red: 0.9254901961, green: 0.9803921569, blue: 0.9254901961, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.9764705882, blue: 0.9411764706, alpha: 1)]
        
        var backgroundImages = backgroundColors.map { color in
            return UIImage.backgroundColorBtnImage(color: color)
        }
        if let image = UIImage(named: "bookReader_icon_background5") {
            backgroundImages += [image]
        }
        return backgroundImages.map { image in
            let btn = UIButton(type: .custom)
            btn.setImage(image, for: .normal)
            btn.setupBorder(cornerRadius: 16)
            btn.addTarget(self, action: #selector(backgroundColorHandler(sender:)), for: .touchUpInside)
            return btn
        }
    }()
    private lazy var styleBtns: [UIButton] = {
        let titles = ["覆盖", "仿真", "平移", "滚动"]
        return titles.map { title in
            let btn = UIButton(type: .system)
            btn.setTitle(title, for: .normal)
            btn.setupBorder(cornerRadius: 10)
            btn.addTarget(self, action: #selector(styleHandler(sender:)), for: .touchUpInside)
            return btn
        }
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        topShadowView.backgroundColor = backgroundColor
        let bgView = UIView()
        bgView.backgroundColor = backgroundColor
        addSubviews([bgView, topShadowView])
        sendSubviewToBack(topShadowView)
        addConstraint(NSLayoutConstraint(item: topShadowView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: topShadowView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: topShadowView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: topShadowView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 10.0))
        addConstraint(NSLayoutConstraint(item: bgView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: bgView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: bgView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: bgView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        var labels = [UILabel]()
        let labelTitles = ["亮度", "字号", "间距", "背景", "翻页"]
        let spaceY: CGFloat = 60.0
        var top: CGFloat = 20.0
        
        labelTitles.forEach { title in
            labels.append(setupTitleLabel(title: title, top: top))
            top = top + spaceY
        }
        
        // 亮度
        let maxBrightnessImageView = UIImageView(image: UIImage.icon(withName: "图标-亮度+", fontSize: 17.4, color: .black))
        let minBrightnessImageView = UIImageView(image: UIImage.icon(withName: "图标-亮度-", fontSize: 17.4, color: .black))
        
        addSubviews([maxBrightnessImageView, minBrightnessImageView, brightnessSlider, useSystemBrightnessBtn])
        
        let lightViews: [String: Any] = [
            "maxBrightnessImageView": maxBrightnessImageView,
            "minBrightnessImageView": minBrightnessImageView,
            "brightnessSlider": brightnessSlider,
            "useSystemBrightnessBtn": useSystemBrightnessBtn,
        ]
        addConstraint(NSLayoutConstraint(item: maxBrightnessImageView, attribute: .centerY, relatedBy: .equal, toItem: labels[0], attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: minBrightnessImageView, attribute: .centerY, relatedBy: .equal, toItem: labels[0], attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: brightnessSlider, attribute: .centerY, relatedBy: .equal, toItem: labels[0], attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: useSystemBrightnessBtn, attribute: .centerY, relatedBy: .equal, toItem: labels[0], attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(80)-[minBrightnessImageView]-[brightnessSlider]-[maxBrightnessImageView]-(22)-[useSystemBrightnessBtn]-(20)-|", metrics: nil, views: lightViews))
        
        // 字号
        addSubviews([smallerFontBtn, biggerFontBtn, fontSizeLabel])
        
        let fontViews = [
            "smallerFontBtn": smallerFontBtn,
            "biggerFontBtn": biggerFontBtn,
            "fontSizeLabel": fontSizeLabel
        ]
        fontSizeLabel.setContentHuggingPriority(UILayoutPriority(10), for: .horizontal)
        addConstraint(NSLayoutConstraint(item: smallerFontBtn, attribute: .centerY, relatedBy: .equal, toItem: labels[1], attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[smallerFontBtn(24)]", metrics: nil, views: fontViews))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[biggerFontBtn(24)]", metrics: nil, views: fontViews))
        addConstraint(NSLayoutConstraint(item: biggerFontBtn, attribute: .centerY, relatedBy: .equal, toItem: labels[1], attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: fontSizeLabel, attribute: .centerY, relatedBy: .equal, toItem: labels[1], attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(80)-[smallerFontBtn(60)]-[fontSizeLabel]-[biggerFontBtn(60)]-(20)-|", metrics: nil, views: fontViews))
        
        let lineSpaceStack = UIStackView(arrangedSubviews: lineSpaceBtns)
        lineSpaceStack.axis = .horizontal
        lineSpaceStack.distribution = .equalSpacing
        addSubviews([lineSpaceStack])
        lineSpaceBtns.forEach { btn in
            btn.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btn(42)]", metrics: nil, views: ["btn": btn]))
            btn.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btn(28)]", metrics: nil, views: ["btn": btn]))
        }
        addConstraint(NSLayoutConstraint(item: lineSpaceStack, attribute: .centerY, relatedBy: .equal, toItem: labels[2], attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(90)-[lineSpaceStack]-(30)-|", metrics: nil, views: ["lineSpaceStack": lineSpaceStack]))
        
        // 背景
        let backgroundColorStack = UIStackView(arrangedSubviews: backgroundColorBtns)
        backgroundColorStack.axis = .horizontal
        backgroundColorStack.distribution = .equalSpacing
        addSubviews([backgroundColorStack])
        backgroundColorBtns.forEach { btn in
            btn.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btn(48)]", metrics: nil, views: ["btn": btn]))
            btn.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btn(32)]", metrics: nil, views: ["btn": btn]))
            btn.imageView?.setupBorder(cornerRadius: 12)
        }
        addConstraint(NSLayoutConstraint(item: backgroundColorStack, attribute: .centerY, relatedBy: .equal, toItem: labels[3], attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(90)-[backgroundColorStack]-(30)-|", metrics: nil, views: ["backgroundColorStack": backgroundColorStack]))
        
        // 翻页
        let pageStack = UIStackView(arrangedSubviews: styleBtns)
        pageStack.axis = .horizontal
        pageStack.distribution = .equalSpacing
        addSubviews([pageStack])
        styleBtns.forEach { btn in
            btn.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btn(48)]", metrics: nil, views: ["btn": btn]))
            btn.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btn(33)]", metrics: nil, views: ["btn": btn]))
        }
        addConstraint(NSLayoutConstraint(item: pageStack, attribute: .centerY, relatedBy: .equal, toItem: labels[4], attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(80)-[pageStack]-(20)-|", metrics: nil, views: ["pageStack": pageStack]))
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
    
    @objc
    private func brightnessChanged(sender: UISlider) {
        renderModel.value.brightness = sender.value
        renderModel.value.useSystemBrightness = false
    }
    
    @objc
    private func brightnessHandler(sender: UIButton) {
        renderModel.value.useSystemBrightness = !renderModel.value.useSystemBrightness
    }
    
    @objc
    private func fontSizeHandler(sender: UIButton) {
        switch sender {
        case biggerFontBtn:
            renderModel.value.increaseFontSize()
        case smallerFontBtn:
            renderModel.value.minusFontSize()
        default:
            break
        }
    }
    
    @objc
    private func lineSpaceHandler(sender: UIButton) {
        if let i = lineSpaceBtns.firstIndex(of: sender) {
            renderModel.value.lineSpaceIndex = i
        }
    }
    
    @objc
    private func backgroundColorHandler(sender: UIButton) {
        if let i = backgroundColorBtns.firstIndex(of: sender) {
            renderModel.value.backgroundColorIndex = i
        }
    }
    
    @objc
    private func styleHandler(sender: UIButton) {
        if let i = styleBtns.firstIndex(of: sender) {
            renderModel.value.styleIndex = i
        }
    }
}

extension UIImage {
    static func backgroundColorBtnImage(color: UIColor) -> UIImage {
        let image = UIImage.init(color: color, size: CGSize(width: 40.0, height: 24.0))
        return image.byRoundCornerRadius(12.0)
    }
}

extension UIButton {
    func setupBorder(cornerRadius: CGFloat) {
        layer.borderColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
    func updateBorder(shown: Bool) {
        layer.borderWidth = shown ? 1.0 : 0.0
    }
}

extension UIImageView {
    func setupBorder(cornerRadius: CGFloat) {
        layer.borderColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1).cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
}
