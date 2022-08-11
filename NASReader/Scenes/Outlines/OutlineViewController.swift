//
//  OutlineViewController.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/20.
//

import UIKit

protocol OutlineViewControllerDelegate: AnyObject {
    func outlineViewController(_ outlineViewController: OutlineViewController, didSelectItem index: Int)
}

class OutlineViewController: UITableViewController, BrightnessSetable {
    struct Constant {
        static let outlineReuseIdentifier = "OutlineItemCell"
    }
    
    private(set) var brightnessView = DYBrightnessView(frame: .zero)
    weak var coordinator: OutlineViewCoordinatorProtocol?
    var outline: OutlineProtocol?
    weak var delegate: OutlineViewControllerDelegate?
    var brightness: Float = 0
    var deepColorIsOpen = false {
        didSet {
            if deepColorIsOpen {
                if #available(iOS 13.0, *) {
                    overrideUserInterfaceStyle = .dark
                } else {
                    // Fallback on earlier versions
                }
            } else {
                if #available(iOS 13.0, *) {
                    overrideUserInterfaceStyle = .unspecified
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            view.backgroundColor = .white
        }
        
        setupUI()
        setBrightness(brightness)
    }
    
    private func setupUI() {
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(OutlineItemCell.self, forCellReuseIdentifier: Constant.outlineReuseIdentifier)
        
        view.addSubview(brightnessView)
        brightnessView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLayoutSubviews() {
        self.brightnessView.frame = tableView.bounds
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.outlineViewController(self, didSelectItem: indexPath.item)
    }
    
}
