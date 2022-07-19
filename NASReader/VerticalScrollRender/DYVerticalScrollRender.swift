//
//  DQVerticalScrollRender.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/2.
//

import UIKit

class DYVerticalScrollRender: UITableViewController, DYRenderProtocol {
    struct ConstValue {
        static let cellReuseId = "cellReuseId"
    }
    
    var currentPage = 0
    var pageNum = 0
    var pageSize: CGSize = .zero
    var pageMaker: ((Int) -> UIView?)?
    var tapFeatureArea: (() -> Void)?
    func showPageAt(_ pageIdx: Int, animated: Bool = false) {
        if (pageIdx < tableView(tableView, numberOfRowsInSection: 0)) {
            tableView.scrollToRow(at: IndexPath(item: pageIdx, section: 0), at: .top, animated: animated)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(DYPageTableViewCell.self, forCellReuseIdentifier: ConstValue.cellReuseId)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tableView.addGestureRecognizer(tap)
    }
    
    @objc
    private func handleTap(sender: UITapGestureRecognizer) {
        tapFeatureArea?()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pageNum
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConstValue.cellReuseId, for: indexPath)
        if let cell = cell as? DYPageTableViewCell, let page = pageMaker?(indexPath.item) {
            cell.page = page
        }
        return cell
    }
    
    // MARK: - TableView delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return pageSize.height
    }


}

