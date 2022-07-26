//
//  DQReaderController.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/2.
//

import UIKit
import DYReader


class DYReaderController: UIViewController {
    @objc enum PageStlye: Int {
        case scrollVertical
        case scrollHorizontal
        case cover
        case curl
    }
    
    @objc var pageStlye = PageStlye.scrollHorizontal {
        didSet {
            buildRender()
        }
    }
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
    
    weak var coordinator: DYReaderCoordinatorProtocol?
    private let bookReader = DYBookReader()
    private var render: DYRenderProtocol?
    private let navigationView = DYReaderNavigationView(frame: .zero)
    private let featureView = DYReaderFeatureView(frame: .zero)
    private let settingView = DYReaderSettingView(frame: .zero)
    private var gestureView: UIView = {
        let v = UIView(frame: .zero)
        v.backgroundColor = .clear
        return v
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
        
        buildRender()
        buildUI()
        setupGestures()
        setupBindables()
    }
    
    private func buildRender() {
        render?.clean()
        
        switch pageStlye {
        case .scrollVertical:
            let render = DYVerticalScrollRender(nibName: nil, bundle: nil)
            render.buildRender(parentController: self)
            render.view.frame = view.bounds.inset(by: UIEdgeInsets(top: 0, left: edgeInsets.left, bottom: 0, right: edgeInsets.right))
            render.tableView.contentInset = UIEdgeInsets(top: edgeInsets.top, left: 0, bottom: edgeInsets.bottom, right: 0)
            render.pageSize = render.view.frame.size
            render.pageNum = Int(bookReader.pageNum)
            render.pageMaker = { [weak self] pageIdx in
                return self?.bookReader.getPageView(atPage: Int32(pageIdx), size: render.pageSize)
            }
            self.render = render
        case .scrollHorizontal:
            let render = DYHorizontalScrollRender(nibName: nil, bundle: nil)
            render.buildRender(parentController: self)
            render.view.frame = view.bounds
            render.pageSize = view.bounds.inset(by: edgeInsets).size
            render.pageNum = Int(bookReader.pageNum)
            render.pageMaker = { [weak self] pageIdx in
                return self?.bookReader.getPageView(atPage: Int32(pageIdx), size: render.pageSize)
            }
            render.showPageAt(2)
            render.coverStyle = true
            self.render = render
        case .cover:
            break
        case .curl:
            break
        }
        self.render?.tapFeatureArea = { [weak self] in
            guard let sself = self else { return }
            sself.featureViewShown = true
        }
    }
    
    private func buildUI() {
        let views: [String: UIView] = [
            "navigationView": navigationView,
            "featureView": featureView,
            "settingView": settingView,
            "gestureView": gestureView,
        ]
        
        [gestureView, navigationView, featureView, settingView, featureView].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            subView.isHidden = true
            setupShadow(view: subView)
            view.addSubview(subView)
        }
        
        settingView.layer.shadowOpacity = 0
        setupShadow(view: settingView.topShadowView)
        
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
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[gestureView]-(0)-|", metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[gestureView]-(0)-|", metrics: nil, views: views))
    }
    
    private func setupShadow(view: UIView) {
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler(sender:)))
        gestureView.addGestureRecognizer(tap)
    }
    
    private func setupBindables() {
        featureView.setupBindables()
    }
    
    @objc
    private func tapHandler(sender: UITapGestureRecognizer) {
        featureViewShown = false
    }
    
    private func showNavigationFeatureViews() {
        navigationView.isHidden = false
        featureView.isHidden = false
        gestureView.isHidden = false
        UIView.animate(withDuration: 0.25) { [weak navigationTopConstraint, weak featureBottomConstraint, weak view] in
            navigationTopConstraint?.constant = 0
            featureBottomConstraint?.constant = 0
            view?.layoutIfNeeded()
        }
    }
    
    private func hideNavigationFeatureViews() {
        featureView.settingShown.value = false
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut) { [weak navigationTopConstraint, weak featureBottomConstraint, weak view] in
            navigationTopConstraint?.constant = -94
            featureBottomConstraint?.constant = 175
            view?.layoutIfNeeded()
        } completion: { [weak navigationView, weak featureView, weak gestureView] _ in
            navigationView?.isHidden = true
            featureView?.isHidden = true
            gestureView?.isHidden = true
        }
    }
    
    
}

extension DYReaderController: DYReaderFeatureViewDelegate {
    func switchToPrevChapter() {
        let switchToChapter = bookReader.chapterIdx - 1
        guard switchToChapter >= 0, bookReader.switchChapter(switchToChapter) else {
            return
        }
        render?.showPageAt(Int(bookReader.pageIdx), animated: false)
    }
    
    func switchToNextChapter() {
        let switchToChapter = bookReader.chapterIdx + 1
        guard switchToChapter < bookReader.chapterList.count, bookReader.switchChapter(switchToChapter) else {
            return
        }
        render?.showPageAt(Int(bookReader.pageIdx), animated: false)
    }
    
    func switchToChapterWithProgress(_ progress: Float) {
        
    }
    
    func showOutlineViews() {
        coordinator?.showOutline(Outline())
    }
    
    func toggleDeepColor(open: Bool) {
        
    }
    
    func toggleSettingView(shown: Bool) {
        if shown {
            view?.bringSubviewToFront(settingView)
        }
        settingView.isHidden = !shown
    }
}
