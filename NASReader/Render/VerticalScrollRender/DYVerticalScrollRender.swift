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
        
    }
    
    func scrollForwardPage(animated: Bool) {
        
    }
    
    func showPage() {
        
    }
    
    struct ConstValue {
        static let cellReuseId = "cellReuseId"
    }
    
    var dataSource: DYRenderDataSource?
    var currentPage = 0
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
        return dataSource?.pageNum ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConstValue.cellReuseId, for: indexPath)
        if let cell = cell as? DYPageTableViewCell, let page = dataSource?.getPageAt(index: indexPath.item) {
            cell.page = page
        }
        return cell
    }
    
    // MARK: - TableView delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource?.pageSize.height ?? 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        switchTo(chapterIndex: <#T##Int#>, pageIndex: <#T##Int#>)
    }


}

