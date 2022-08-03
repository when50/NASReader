//
//  DQReaderController.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/2.
//

import UIKit
import DYReader


class DYReaderController: UIViewController, BrightnessSetable, DYReaderContainer {
    
    @objc var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20)
    
    private var featureViewShown = false {
        didSet {
            if featureViewShown {
                showNavigationFeatureViews()
            } else {
                hideNavigationFeatureViews()
            }
        }
    }
    
    private let bookReader = DYBookReader()
    private var renderModel = Bindable(DYRenderModel(brightness: 1.0, useSystemBrightness: true, fontSize: 20))
    
    weak var coordinator: DYReaderCoordinatorProtocol?
    
    private var invalidRenderContent = Bindable(false)
    private var rollbackChapterIndex = Bindable(0)
    private var render: DYRenderProtocol?
    private let navigationView = DYReaderNavigationView(frame: .zero)
    private let featureView = DYReaderFeatureView(frame: .zero)
    private lazy var settingView: DYReaderSettingView = {
        let v = DYReaderSettingView(frame: .zero)
        v.delegate = self
        return v
    }()
    var containerView: UIView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bundle = Bundle.main
        if let bookfile = bundle.path(forResource: "TLYCSEbookDec2020FINAL", ofType: "epub") {
            bookReader.openFile(bookfile)
        }
        
        featureView.delegate = self
        
        loadHistory()
        buildUI()
        setupBindables()
        
        self.renderModel.value = DYRenderModel(brightness: 0.0, useSystemBrightness: false, fontSize: 18)
        invalidRenderContent.value = true
    }
    
    private func loadHistory() {
        
    }
    
    private func buildUI() {
        let views: [String: UIView] = [
            "containerView": containerView,
            "navigationView": navigationView,
            "featureView": featureView,
            "settingView": settingView,
            "rollbackView": rollbackView,
            "brightnessView": brightnessView,
        ]
        
        [containerView,
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
        
        containerView.frame = view.bounds
        containerView.layer.shadowOpacity = 0
        containerView.isHidden = false
        brightnessView.layer.shadowOpacity = 0
        brightnessView.isHidden = false
        settingView.layer.shadowOpacity = 0
        setupShadow(view: settingView.topShadowView)
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|",
                                           metrics: nil,
                                           views: ["containerView": containerView]))
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|",
                                           metrics: nil,
                                           views: ["containerView": containerView]))
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
        
        render?.clean()
        render = nil
        
        var pageSize = view.bounds.size
        switch style {
        case .scrollVertical:
            let render = DYVerticalScrollRender(nibName: nil, bundle: nil)
            render.buildRender(parentController: self)
            render.view.frame = view.bounds.inset(by: UIEdgeInsets(top: 0, left: edgeInsets.left, bottom: 0, right: edgeInsets.right))
            render.tableView.contentInset = UIEdgeInsets(top: edgeInsets.top, left: 0, bottom: edgeInsets.bottom, right: 0)
            pageSize = render.view.frame.size
            self.render = render
        case .scrollHorizontal, .cover:
            let render = DYHorizontalScrollRender(nibName: nil, bundle: nil)
            render.buildRender(parentController: self)
            render.view.frame = view.bounds
            render.coverStyle = style == .cover
            pageSize = view.bounds.inset(by: edgeInsets).size
            self.render = render
        case .curl:
            break
        }
        render?.dataSource = DYRenderDataSourceImpl(reader: bookReader, pageSize: pageSize)
        invalidRenderContent.value = true
    }
    
    private func setupShadow(view: UIView) {
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
    }
    
    private func setupBindables() {
        featureView.setupBindables()
        invalidRenderContent.bind { [weak self] in
            if $0 {
                self?.updateRenderContent()
            }
        }
        rollbackChapterIndex.bind { [weak self] in
            self?.updateRollbackInfo(chapterIndex: $0)
        }
        renderModel.bind { [weak self] value in
            // seriallize
            if value.useSystemBrightness {
                self?.setBrightness(1)
            } else {
                self?.setBrightness(value.brightness)
            }
            self?.settingView.updateRenderModel(value)
            self?.setupRender(style: value.style)
        }
    }
    
    private func updateRenderContent(animated: Bool = false) {
        render?.scrollBackwardPage(animated: false)
        
        if let progress = bookReader.chapterProgress(chaterIndex: Int(bookReader.chapterIdx)) {
            featureView.progressSlider.progress = CGFloat(progress)
        }
        
        invalidRenderContent.value = false
        
        rollbackChapterIndex.value = Int(bookReader.chapterIdx)
    }
    
    private func updateRollbackInfo(chapterIndex: Int) {
        if let chapter = bookReader.getChapterAt(Int32(chapterIndex)) {
            let progress = bookReader.chapterProgress(chaterIndex: chapterIndex) ?? 0
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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension DYReaderController: DYRenderDelegate {
    func render(_ render: DYRenderProtocol, didTap operation: DYGestureViewOperation) {
        if featureViewShown {
            featureViewShown = false
        } else {
            switch operation {
            case .scrollBackword:
                let pageIdx = Int(bookReader.pageIdx) - 1
                guard pageIdx >= 0 else { return }
                guard let chapterIdx = bookReader.getChapterIndex(pageIndex: pageIdx) else { return }
                if bookReader.isValidPageIndex(pageIdx) && bookReader.isValidChapterIndex(chapterIdx) {
                    bookReader.pageIdx = Int32(pageIdx)
                    bookReader.chapterIdx = Int32(chapterIdx)
                    render.scrollBackwardPage(animated: true)
                }
                
            case .scrollForward:
                let pageIdx = Int(bookReader.pageIdx) + 1
                guard pageIdx < bookReader.pageNum else { return }
                guard let chapterIdx = bookReader.getChapterIndex(pageIndex: pageIdx) else { return }
                if bookReader.isValidPageIndex(pageIdx) && bookReader.isValidChapterIndex(chapterIdx) {
                    bookReader.pageIdx = Int32(pageIdx)
                    bookReader.chapterIdx = Int32(chapterIdx)
                    render.scrollForwardPage(animated: true)
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
        if let chapterIndex = bookReader.chapterIndex(progress: progress) {
            rollbackChapterIndex.value = chapterIndex
        }
    }
    
    func slidingChapterProgressEnd(_ progress: Float) {
        guard let switchToChapter = bookReader.chapterIndex(progress: progress) else { return }
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
        coordinator?.showOutline(
            for: Outline(items: items),
            delegate: self,
            brightness: renderModel.value.useSystemBrightness ? 1.0 : renderModel.value.brightness)
    }
    
    func toggleDeepColor(open: Bool) {
        
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

extension DYBookReader {
    func chapterIndex(progress: Float) -> Int? {
        guard chapterList.count > 0 else { return nil }
        return Int(Float(chapterList.count - 1) * progress)
    }
    
    func chapterProgress(chaterIndex: Int) -> Float? {
        guard chapterList.count > 0 else { return nil }
        return Float(chaterIndex) / Float(chapterList.count - 1)
    }
}

extension DYBookReader {
    func isValidPageIndex(_ index: Int) -> Bool { (0..<Int(pageNum)).contains(index) }
    func isValidChapterIndex(_ index: Int) -> Bool { (0..<chapterList.count).contains(index) }
}
