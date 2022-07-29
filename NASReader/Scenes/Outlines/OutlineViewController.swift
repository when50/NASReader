//
//  OutlineViewController.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/20.
//

import UIKit

class OutlineViewController: UITableViewController {
    struct Constant {
        static let outlineReuseIdentifier = "OutlineItemCell"
    }
    
    weak var coordinator: OutlineViewCoordinatorProtocol?
    var outline: OutlineProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            view.backgroundColor = .white
        }
        
        setupUI()
    }
    
    private func setupUI() {
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(OutlineItemCell.self, forCellReuseIdentifier: Constant.outlineReuseIdentifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outline?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.outlineReuseIdentifier)!
        if let cell = cell as? OutlineItemCell, let item = outline?.itemAt(index: indexPath.item) {
            cell.setViewModel(item: item)
        }
        return cell
    }
    
}
