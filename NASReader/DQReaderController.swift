//
//  DQReaderController.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/2.
//

import UIKit
import DYReader

class DQReaderController: UIViewController {
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
    private var render: DQRender?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let bundle = Bundle.main
        if let bookfile = bundle.path(forResource: "TLYCSEbookDec2020FINAL", ofType: "epub") {
            bookReader.openFile(bookfile)
        }
        buildRender()
    }
    
    private func buildRender() {
        render?.clean()
        
        switch pageStlye {
        case .scrollVertical:
            let render = DQVerticalScrollRender(nibName: nil, bundle: nil)
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
            let render = DQHorizontalScrollRender(nibName: nil, bundle: nil)
            render.buildRender(parentController: self)
            render.view.frame = view.bounds.inset(by: UIEdgeInsets(top: 0, left: edgeInsets.left, bottom: 0, right: edgeInsets.right))
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

}
