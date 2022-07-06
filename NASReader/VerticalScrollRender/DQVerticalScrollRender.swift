//
//  DQVerticalScrollRender.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/2.
//

import UIKit

class DQVerticalScrollRender: UITableViewController, DQRender {
    struct ConstValue {
        static let cellReuseId = "cellReuseId"
    }
    
    var currentPage = 0
    var pageNum = 0
    var pageSize: CGSize = .zero
    var pageMaker: ((Int) -> UIView?)?
    
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
        tableView.register(DQPageCell.self, forCellReuseIdentifier: ConstValue.cellReuseId)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        if let cell = cell as? DQPageCell, let page = pageMaker?(indexPath.item) {
            cell.page = page
        }
        return cell
    }
    
    // MARK: - TableView delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return pageSize.height
    }


}

