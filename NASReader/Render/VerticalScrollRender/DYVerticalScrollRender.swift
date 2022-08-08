//
//  DQVerticalScrollRender.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/2.
//

import UIKit

class DYVerticalScrollRender: UITableViewController, DYRenderProtocol {
    func supportStyle(style: DYRenderModel.Style) -> Bool {
        return style == .scrollVertical
    }
    
    func scrollBackwardPage(animated: Bool) {
        let indexPath = IndexPath(item: renderDataSource?.currentPageIdx ?? 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
    }
    
    func scrollForwardPage(animated: Bool) {
        let indexPath = IndexPath(item: renderDataSource?.pageNum ?? 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
    }
    
    struct ConstValue {
        static let cellReuseId = "cellReuseId"
    }
    
    var renderDelegate: DYRenderDelegate?
    var renderDataSource: DYRenderDataSource? {
        didSet {
            tableView.reloadData()
        }
    }
    func showPageAt(_ pageIdx: Int, animated: Bool = false) {
        if (pageIdx < tableView(tableView, numberOfRowsInSection: 0)) {
            tableView.scrollToRow(at: IndexPath(item: pageIdx, section: 0), at: .top, animated: animated)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        tableView.isOpaque = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(DYPageTableViewCell.self, forCellReuseIdentifier: ConstValue.cellReuseId)

        setupGestures()
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func handleTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        let range = view.frame.size.width
        if range > 0 {
            processTapAt(location: Float(location.x / range))
        }
    }
    
    func buildRender(parentController: UIViewController) {
        if let delegate = parentController as? DYRenderDelegate {
            self.renderDelegate = delegate
        }
        parentController.addChild(self)
        view.translatesAutoresizingMaskIntoConstraints = false
        if let container = parentController as? DYReaderContainer {
            container.containerView.addSubview(view)
            view.frame = container.containerView.bounds
            NSLayoutConstraint.activate(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                               metrics: nil,
                                               views: ["view": view!]))
            NSLayoutConstraint.activate(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                               metrics: nil,
                                               views: ["view": view!]))
        }
        didMove(toParent: parentController)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return renderDataSource?.pageNum ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConstValue.cellReuseId, for: indexPath)
        if let cell = cell as? DYPageTableViewCell, let page = renderDataSource?.getPageAt(index: indexPath.item) {
            cell.page = page
            page.isUserInteractionEnabled = false
        }
        return cell
    }
    
    // MARK: - TableView delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return renderDataSource?.pageSize.height ?? 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        switchTo(chapterIndex: <#T##Int#>, pageIndex: <#T##Int#>)
    }


}

