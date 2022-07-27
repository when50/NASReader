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
    var outlineItems: [OutlineItem] = []

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
        tableView.register(OutlineItemCell.self, forCellReuseIdentifier: Constant.outlineReuseIdentifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outlineItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.outlineReuseIdentifier)!
        if let cell = cell as? OutlineItemCell {
            cell.setViewModel(item: outlineItems[indexPath.item], isCurrent: false)
        }
        return cell
    }
    
}
