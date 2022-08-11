//
//  ViewController.swift
//  NASReader
//
//  Created by oneko.c on 2022/8/11.
//

import UIKit
import DYReader

class ViewController: UIViewController {
    private lazy var coordinator: DYReaderCoordinator = {
        let coordinator = DYReaderCoordinator(navigationController: navigationController!)
        return coordinator
    }()
    override func viewDidLoad() {
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 100, y: 100, width: 80, height: 40)
        btn.setTitle("打开", for: .normal)
        btn.addTarget(self, action: #selector(open(sender:)), for: .touchUpInside)
        view.addSubview(btn)
    }
    
    @objc
    private func open(sender: UIButton) {
        coordinator.start()
        
    }
}
