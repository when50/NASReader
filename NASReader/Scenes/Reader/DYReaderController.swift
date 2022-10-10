//
//  DQReaderController.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/2.
//

import UIKit
import DYReader

public class DYReaderController: UIViewController, BrightnessSetable, DYReaderContainer {
    var bookReader = DYBookReader()
    var bookPath: String?
    var renderConfig: [String: AnyObject] = [:]
    var pageIndex: Int = 0
    var renderConfigChangedCallback: (([String: AnyObject]) -> Void)?
    var pageIndexChangedCallback: ((Int) -> Void)?
    
    @objc var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    private var featureViewShown = false {
        didSet {
            if featureViewShown {
                showNavigationFeatureViews()
            } else {
                hideNavigationFeatureViews()
            }
        }
    }
    
    private var renderModel = Bindable(DYRenderModel(brightness: 1.0, useSystemBrightness: false, fontSize: 20))
    
    weak var coordinator: DYReaderCoordinatorProtocol?
    
    private var invalidRenderContent = Bindable(false)
    private var rollbackChapterIndex = Bindable(0)
    private var render: DYRenderProtocol?
    private lazy var navigationView: DYReaderNavigationView = {
        let v = DYReaderNavigationView(frame: .zero)
        v.delegate = self
        return v
    }()
    
    
    private var deepColorIsOpen = Bindable(false)
    private lazy var featureView: DYReaderFeatureView = {
        let v = DYReaderFeatureView(frame: .zero)
        v.delegate = self
        return v
    }()
    private lazy var settingView: DYReaderSettingView = {
        let v = DYReaderSettingView(frame: .zero)
        v.delegate = self
        return v
    }()
    private let backgroundView = DNReaderBackgroundView(frame: .zero)
    private(set) var containerView: UIView = {
        let v = UIView(frame: .zero)
        v.backgroundColor = .clear
        return v
    }()
    private(set) var brightnessView = DYBrightnessView(frame: .zero)
    private lazy var rollbackView: DYRollbackChapterView = {
        let view = DYRollbackChapterView(frame: .zero)
        view.rollback = { [weak self] in
            self?.bookReader.rollbackChapter()
            self?.invalidRenderContent.value = true
        }
        return view
    }()
    private var navigationTopConstraint: NSLayoutConstraint?
    private var featureBottomConstraint: NSLayoutConstraint?
    private var settingBottomConstraint: NSLayoutConstraint?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if (bookPath?.count ?? 0) == 0 {
            let bundle = Bundle.main
            if let bookfile = bundle.path(forResource: "每天懂一点好玩心理学", ofType: "epub") {
                bookPath = bookfile
            }
        }
        if let bookfile = bookPath {
            bookReader.openFile(bookfile) { [weak self] successed in
                guard let wself = self else { return }
                wself.buildUI()
                wself.setupBindables()
                
                wself.renderModel.value = DYRenderModel.modelWithDictionary(wself.renderConfig)
                
                DispatchQueue.main.async {
                    wself.readFromHistory()
                }
            }
        }
        
        
    }
    
    private func readFromHistory() {
        print("readFrom History");
        let chapterIndex = bookReader.getChapterIndex(withPageIndex: Int32(self.pageIndex))
        bookReader.pageIdx = Int32(self.pageIndex)
        bookReader.chapterIdx = chapterIndex
        self.invalidRenderContent.value = true
    }
    
    private func buildUI() {
        let views: [String: UIView] = [
            "backgroundView": backgroundView,
            "containerView": containerView,
            "navigationView": navigationView,
            "featureView": featureView,
            "settingView": settingView,
            "rollbackView": rollbackView,
            "brightnessView": brightnessView,
        ]
        
        [backgroundView,
         containerView,
         navigationView,
         featureView,
         settingView,
         featureView,
         rollbackView,
         brightnessView].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            subView.isHidden = true
            setupShadow(view: subView)
            view.addSubview(subView)
        }
        
        backgroundView.isHidden = false
        containerView.frame = view.bounds
        containerView.layer.shadowOpacity = 0
        containerView.isHidden = false
        brightnessView.layer.shadowOpacity = 0
        brightnessView.isHidden = false
        settingView.layer.shadowOpacity = 0
        setupShadow(view: settingView.topShadowView)
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundView]|", metrics: nil, views: ["backgroundView": backgroundView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundView]|", metrics: nil, views: ["backgroundView": backgroundView]))
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|",
                                           metrics: nil,
                                           views: ["containerView": containerView]))
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: containerView,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: view.safeAreaLayoutGuide,
                                   attribute: .top,
                                   multiplier: 1.0,
                                   constant: 0.0),
                NSLayoutConstraint(item: containerView,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: view.safeAreaLayoutGuide,
                                   attribute: .bottom,
                                   multiplier: 1.0,
                                   constant: 0.0)
            ])
        } else {
            NSLayoutConstraint.activate(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|",
                                               metrics: nil,
                                               views: ["containerView": containerView]))
        }
        let top = NSLayoutConstraint(item: navigationView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: -94)
        view.addConstraint(top)
        navigationTopConstraint = top
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[navigationView(94)]", metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[navigationView]-(0)-|", metrics: nil, views: views))
        
        let bottom = NSLayoutConstraint(item: featureView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 175)
        view.addConstraint(bottom)
        featureBottomConstraint = bottom
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[featureView(175)]", metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[featureView]-(0)-|", metrics: nil, views: views))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[settingView(334)]-(98)-|", metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[settingView]-(0)-|", metrics: nil, views: views))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[rollbackView(48)]-(98)-[featureView]", metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[rollbackView]-(20)-|", metrics: nil, views: views))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[brightnessView]-(0)-|", metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[brightnessView]-(0)-|", metrics: nil, views: views))
    }
    
    private func setupRender(style: DYRenderModel.Style) {
        if render?.supportStyle(style: style) ?? false { return }
        
        render?.doRelease()
        render = nil
        
        switch style {
        case .scrollVertical:
            let render = DYVerticalScrollRender(nibName: nil, bundle: nil)
            render.buildRender(parentController: self)
            self.render = render
        case .scrollHorizontal:
            let render = DYHorizontalScrollRenderViewController(nibName: nil, bundle: nil)
            render.buildRender(parentController: self)
            self.render = render
        case .cover:
            let render = DYCoverRender(nibName: nil, bundle: nil)
            render.buildRender(parentController: self)
            self.render = render
        case .curl:
            let render = DYCurlRenderViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal)
            render.buildRender(parentController: self)
            self.render = render
        }
        let pageIdx = bookReader.pageIdx
        let chapterIdx = bookReader.chapterIdx
        bookReader.switch(toPage: pageIdx, chapter: chapterIdx)
        render?.renderDataSource = DYRenderDataSourceImpl(reader: bookReader)
        view.setNeedsLayout()
        invalidRenderContent.value = true
    }
    
    public override func viewDidLayoutSubviews() {
        let containerWidth = containerView.frame.size.width
        let containerHeight = containerView.frame.size.height
        if bookReader.pageSize.width != containerWidth ||
            bookReader.pageSize.height != containerHeight {
            if let _ = render {
                bookReader.pageSize = containerView.frame.size
//                bookReader.layoutPageOutlines()
                invalidRenderContent.value = true
            }
        }
    }
    
    private func setupShadow(view: UIView) {
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
    }
    
    private func setupBindables() {
        featureView.setupBindables()
        deepColorIsOpen.bind { [weak self] value in
            self?.setNeedsStatusBarAppearanceUpdate()
            self?.featureView.deepColorIsOpen.value = value
        }
        invalidRenderContent.bind { [weak self] in
            if $0 {
                self?.updateRenderContent()
            }
        }
        rollbackChapterIndex.bind { [weak self] in
            self?.updateRollbackInfo(chapterIndex: $0)
        }
        renderModel.bind { [weak self] value in
            self?.renderConfigChangedCallback?(value.toDictionary())
            // seriallize
            if value.useSystemBrightness {
                self?.setBrightness(1)
            } else {
                self?.setBrightness(value.brightness)
            }
            self?.settingView.updateRenderModel(value)
            self?.setupRender(style: value.style)
            
            self?.bookReader.updateFontSize(CGFloat(value.fontSize)) { changed in
                if changed {
                    self?.render?.cleanCache()
                    self?.invalidRenderContent.value = true
                } else {
                    print("书籍格式不支持修改字体（如PDF）")
                }
            }
            
            if let styles = self?.backgroundStyles, styles.indices.contains(value.backgroundColorIndex) {
                let (color, _) = styles[value.backgroundColorIndex]
                let bundle = Bundle(for: DYReaderController.self)
                var image: UIImage? = nil
                if let self = self {
                    image = UIImage(named: self.backgroundImageName, in: bundle, compatibleWith: self.traitCollection)
                }
                if let config = color ?? image {
                    self?.backgroundView.update(config: config)
                    
                    if let render = self?.render as? DYFullScreenRenderProtocol {
                        render.updateBackground(config)
                    }
                }
            }
        }
    }
    
    private func updateRenderContent(animated: Bool = false) {
        render?.scrollToCurrentPage(animated: animated)
        
        let progress = bookReader.chapterProgress(bookReader.chapterIdx)
        featureView.progressSlider.progress = CGFloat(progress)
        
        invalidRenderContent.value = false
        
        rollbackChapterIndex.value = Int(bookReader.chapterIdx)
    }
    
    private func updateRollbackInfo(chapterIndex: Int) {
        if let chapter = bookReader.getChapterAt(Int32(chapterIndex)) {
            let progress = bookReader.chapterProgress(Int32(chapterIndex))
            rollbackView.updateChapter(chapter.title, locationPercent: CGFloat(progress), rollbackEnabled: true)
        }
    }
    
    private func showNavigationFeatureViews() {
        navigationView.isHidden = false
        featureView.isHidden = false
        UIView.animate(withDuration: 0.25) { [weak navigationTopConstraint, weak featureBottomConstraint, weak view] in
            navigationTopConstraint?.constant = 0
            featureBottomConstraint?.constant = 0
            view?.layoutIfNeeded()
        }
    }
    
    private func hideNavigationFeatureViews() {
        rollbackView.isHidden = true
        featureView.settingShown.value = false
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut) { [weak navigationTopConstraint, weak featureBottomConstraint, weak view] in
            navigationTopConstraint?.constant = -94
            featureBottomConstraint?.constant = 175
            view?.layoutIfNeeded()
        } completion: { [weak navigationView, weak featureView] _ in
            navigationView?.isHidden = true
            featureView?.isHidden = true
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension DYReaderController: DYReaderNavigationViewDelegate {
    func navigationViewTapBack(_ view: DYReaderNavigationView) {
        navigationController?.popViewController(animated: true)
    }
}

extension DYReaderController: DYRenderDelegate {
    func render(_ render: DYRenderProtocol, switchTo page: Int, chapter: Int) {
        if bookReader.isValidPageIndex(Int32(page)) && bookReader.isValidChapterIndex(Int32(chapter)) {
            bookReader.switch(toPage: Int32(page), chapter: Int32(chapter))
            pageIndexChangedCallback?(page)
        }
    }
    
    func render(_ render: DYRenderProtocol, didTap operation: DYGestureViewOperation) {
        if featureViewShown {
            featureViewShown = false
        } else {
            switch operation {
            case .scrollBackword:
                let pageIdx = Int(bookReader.pageIdx) - 1
                guard pageIdx >= 0 else { return }
                let chapterIdx = Int(bookReader.getChapterIndex(withPageIndex: Int32(pageIdx)))
                if bookReader.isValidPageIndex(Int32(pageIdx)) && bookReader.isValidChapterIndex(Int32(chapterIdx)) {
                    bookReader.switch(toPage: Int32(pageIdx), chapter: Int32(chapterIdx))
                    pageIndexChangedCallback?(pageIdx)
                    render.scrollToCurrentPage(animated: true)
                }
                
            case .scrollForward:
                let pageIdx = Int(bookReader.pageIdx) + 1
                guard pageIdx < bookReader.pageNum else { return }
                let chapterIdx = Int(bookReader.getChapterIndex(withPageIndex: Int32(pageIdx)))
                if bookReader.isValidPageIndex(Int32(pageIdx)) && bookReader.isValidChapterIndex(Int32(chapterIdx)) {
                    bookReader.switch(toPage: Int32(pageIdx), chapter: Int32(chapterIdx))
                    pageIndexChangedCallback?(pageIdx)
                    render.scrollToCurrentPage(animated: true)
                }
            case .toggleNavigationFeautre:
                featureViewShown = true
            }
        }
    }
}

extension DYReaderController: DYReaderFeatureViewDelegate {
    func switchToPrevChapter() {
        let switchToChapter = bookReader.chapterIdx - 1
        guard bookReader.switchChapter(switchToChapter) else {
            return
        }
        invalidRenderContent.value = true
    }
    
    func switchToNextChapter() {
        let switchToChapter = bookReader.chapterIdx + 1
        guard bookReader.switchChapter(switchToChapter) else {
            return
        }
        invalidRenderContent.value = true
    }
    
    func slidingChapterBegin() {
        if rollbackView.isHidden {
            bookReader.recordCurrentChapter()
        }
    }
    
    func slidingChapterProgress(_ progress: Float) {
        rollbackView.isHidden = false
        let chapterIndex = bookReader.chapterIndex(withProgress: progress)
        rollbackChapterIndex.value = Int(chapterIndex)
    }
    
    func slidingChapterProgressEnd(_ progress: Float) {
        let switchToChapter = bookReader.chapterIndex(withProgress: progress)
        if bookReader.switchChapter(Int32(switchToChapter)) {
            invalidRenderContent.value = true
        }
    }
    
    func showOutlineViews() {
        guard let chapterList = bookReader.chapterList as? [DYChapter] else {
            print("\(bookReader.chapterList) can not convert [DYChapter]")
            return
        }
        var items = [OutlineItem]()
        for i in chapterList.indices {
            let item = OutlineItem(chapter: chapterList[i],
                                   cached: true,
                                   isCurrent: i == bookReader.chapterIdx)
            items += [item]
        }
        let brightness = renderModel.value.useSystemBrightness ? 1.0 : renderModel.value.brightness
        coordinator?.showOutline(
            for: Outline(items: items),
            delegate: self,
            brightness: brightness,
            deepColorIsOpen: deepColorIsOpen.value)
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return deepColorIsOpen.value ? .lightContent : .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    
    func toggleDeepColor() {
        deepColorIsOpen.value = !deepColorIsOpen.value
        if deepColorIsOpen.value {
            if #available(iOS 13.0, *) {
                overrideUserInterfaceStyle = .dark
            } else {
                // Fallback on earlier versions
            }
        } else {
            if #available(iOS 13.0, *) {
                overrideUserInterfaceStyle = .unspecified
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func toggleSettingView(shown: Bool) {
        if shown {
            view?.bringSubviewToFront(settingView)
            rollbackView.isHidden = true
        }
        settingView.isHidden = !shown
        view.bringSubviewToFront(brightnessView)
    }
}

extension DYReaderController: DYReaderSettingViewDelegate {
    func settingView(_ view: DYReaderSettingView, didChanged renderModel: DYRenderModel) {
        if renderModel != self.renderModel.value {
            self.renderModel.value = renderModel
        }
    }
}

extension DYReaderController: OutlineViewControllerDelegate {
    func outlineViewController(_ outlineViewController: OutlineViewController,
                               didSelectItem index: Int) {
        bookReader.switchChapter(Int32(index))
        invalidRenderContent.value = true
        dismiss(animated: true)
    }
}

extension DYReaderController {
    struct Constant {
        static let backgroundImageName = "bookReader_page_background"
        static let customCss = "@page{margin:0em 0em}" +
        "a{color:#06C;text-decoration:underline}" +
        "address{display:block;font-style:italic}" +
        "b{font-weight:bold}" +
        "bdo{direction:rtl;unicode-bidi:bidi-override}" +
        "blockquote{display:block;margin:1em 40px}" +
        "body{display:block;margin:1em}" +
        "cite{font-style:italic}" +
        "code{font-family:monospace}" +
        "dd{display:block;margin:0 0 0 40px}" +
        "del{text-decoration:line-through}" +
        "div{display:block}" +
        "dl{display:block;margin:1em 0}" +
        "dt{display:block}" +
        "em{font-style:italic}" +
        "h1{display:block;font-size:2em;font-weight:bold;margin:0.67em 0;page-break-after:avoid}" +
        "h2{display:block;font-size:1.5em;font-weight:bold;margin:0.83em 0;page-break-after:avoid}" +
        "h3{display:block;font-size:1.17em;font-weight:bold;margin:1em 0;page-break-after:avoid}" +
        "h4{display:block;font-size:1em;font-weight:bold;margin:1.33em 0;page-break-after:avoid}" +
        "h5{display:block;font-size:0.83em;font-weight:bold;margin:1.67em 0;page-break-after:avoid}" +
        "h6{display:block;font-size:0.67em;font-weight:bold;margin:2.33em 0;page-break-after:avoid}" +
        "head{display:none}" +
        "hr{border-style:solid;border-width:1px;display:block;margin-bottom:0.5em;margin-top:0.5em;text-align:center}" +
        "html{display:block}" +
        "i{font-style:italic}" +
        "ins{text-decoration:underline}" +
        "kbd{font-family:monospace}" +
        "li{display:list-item}" +
        "menu{display:block;list-style-type:disc;margin:1em 0;padding:0 0 0 30pt}" +
        "ol{display:block;list-style-type:decimal;margin:1em 0;padding:0 0 0 30pt}" +
        "p{display:block;margin:1em 0}" +
        "pre{display:block;font-family:monospace;margin:1em 0;white-space:pre}" +
        "samp{font-family:monospace}" +
        "script{display:none}" +
        "small{font-size:0.83em}" +
        "strong{font-weight:bold}" +
        "style{display:none}" +
        "sub{font-size:0.83em;vertical-align:sub}" +
        "sup{font-size:0.83em;vertical-align:super}" +
        "table{display:table}" +
        "tbody{display:table-row-group}" +
        "td{display:table-cell;padding:1px}" +
        "tfoot{display:table-footer-group}" +
        "th{display:table-cell;font-weight:bold;padding:1px;text-align:center}" +
        "thead{display:table-header-group}" +
        "tr{display:table-row}" +
        "ul{display:block;list-style-type:disc;margin:1em 0;padding:0 0 0 30pt}" +
        "ul ul{list-style-type:circle}" +
        "ul ul ul{list-style-type:square}" +
        "var{font-style:italic}" +
        "svg{display:none}"
    }
    
    var backgroundImageName: String {
        return Constant.backgroundImageName
    }
    
    var customReaderCss: String {
        return Constant.customCss
    }
    
    var backgroundStyles: [(UIColor?, UIImage?)] {
        var backgrounds: [(UIColor?, UIImage?)] = []
        let backgroundColors = [#colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.9176470588, blue: 0.8117647059, alpha: 1), #colorLiteral(red: 0.9254901961, green: 0.9803921569, blue: 0.9254901961, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.9764705882, blue: 0.9411764706, alpha: 1)]
        backgroundColors.forEach { color in
            backgrounds.append((color, nil))
        }
        
        let bundle = Bundle(for: DYReaderController.self)
        if let image = UIImage(named: "bookReader_icon_background5", in: bundle, compatibleWith: traitCollection) {
            backgrounds.append((nil, image))
        }
        return backgrounds
    }
    
    
}
