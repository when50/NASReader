//
//  DYPageViewController.swift
//  NASReader
//
//  Created by oneko.c on 2022/8/8.
//

import UIKit

class DYPageViewController: UIViewController {
    var pageIdx = 0
    var pageView: UIView? {
        didSet {
            view.setNeedsLayout()
        }
    }
    let backgroundView = DNReaderBackgroundView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        if let pageView = pageView {
            pageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(pageView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        backgroundView.frame = view.bounds
        if #available(iOS 11.0, *) {
            pageView?.frame = view.bounds.inset(by: view.safeAreaInsets)
        } else {
            // Fallback on earlier versions
            pageView?.frame = view.bounds
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
