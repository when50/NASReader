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
    
    private let bookReader = DYBookReader()
    private var render: DYRenderProtocol?
    private let navigationView = DYReaderNavigationView(frame: .zero)
    private var featureView = DYReaderFeatureView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        let bundle = Bundle.main
        if let bookfile = bundle.path(forResource: "TLYCSEbookDec2020FINAL", ofType: "epub") {
            bookReader.openFile(bookfile)
        }
        buildRender()
        
        buildUI()
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
        
    }
    
    private func buildUI() {
        let views: [String: Any] = [
            "navigationView": navigationView,
            "featureView": featureView
        ]
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        setupShadow(view: navigationView)
        view.addSubview(navigationView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[navigationView(==94)]", metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[navigationView]-(0)-|", metrics: nil, views: views))
        
        featureView.translatesAutoresizingMaskIntoConstraints = false
        setupShadow(view: featureView)
        view.addSubview(featureView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[featureView(==175)]-(0)-|", metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[featureView]-(0)-|", metrics: nil, views: views))
    }
    
    private func setupShadow(view: UIView) {
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
    }

}
