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
    
    func scrollToCurrentPage(animated: Bool) {
        if let row = renderDataSource?.currentPageIdx, row > 0 {
            let indexPath = IndexPath(item: row - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
    
    weak var renderDelegate: DYRenderDelegate?
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
        tableView.register(DYPageTableViewCell.self, forCellReuseIdentifier: cellReuseId)

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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
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
    
    private func updatePageIndex() {
        guard let renderDataSource = renderDataSource else { return }
        let visibleCells = tableView.visibleCells
        guard let cell = visibleCells.filter({ cell in
            if let frame = tableView.superview?.convert(cell.frame, from: tableView) {
                return frame.contains(tableView.center)
            } else {
                return false
            }
        }).first else {
            return
        }
        if let pageIdx = tableView.indexPath(for: cell)?.item,
           let chapterIdx = renderDataSource.getChapterIndex(pageIndex: pageIdx) {
            renderDelegate?.render(self, switchTo: pageIdx, chapter: chapterIdx)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        updatePageIndex()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updatePageIndex()
    }


}

extension DYVerticalScrollRender {
    
    struct ConstValue {
        static let cellReuseId = "cellReuseId"
    }
    
    var cellReuseId: String {
        return ConstValue.cellReuseId
    }
}

