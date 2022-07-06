//
//  DQHorizontalScrollRender.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/4.
//

import UIKit

class DQHorizontalScrollRender: UIViewController, DQRender {
    struct ConstValue {
        static let scrollTapRange = 0.3
    }
    
    var coverStyle = false
    var currentPage = 0
    var pageNum = 0
    var pageSize: CGSize = .zero
    var pageMaker: ((Int) -> UIView?)?
    private var showPageBlock: (() -> Void)?
    private var pageView: UIView?
    
    func showPageAt(_ pageIdx: Int, animated: Bool = false) {
        currentPage = pageIdx
        if let page = pageMaker?(pageIdx) {
            page.frame = view.bounds
            view.addSubview(page)
            pageView = page
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addScrollGestureRecognizers()
    }
    
    private func addScrollGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler(sender:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func tapHandler(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        let scaledLocation = location.x / view.frame.width
        switch scaledLocation {
        case let v where v < ConstValue.scrollTapRange:
            print("scroll backwards")
            if currentPage > 0 {
                let oldPage = pageView
                showPageAt(currentPage - 1, animated: true)
                pageView?.frame = view.bounds.offsetBy(dx: -view.bounds.width, dy: 0)
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState) {
                    self.pageView?.frame = self.view.bounds
                    oldPage?.frame = self.view.bounds.offsetBy(dx: self.view.bounds.width, dy: 0)
                } completion: { _ in
                    oldPage?.removeFromSuperview()
                }

            } else {
                print("is first page")
            }
        case let v where v + ConstValue.scrollTapRange > 1.0:
            print("scroll forward")
            if currentPage + 1 < pageNum {
                let oldPage = pageView
                showPageAt(currentPage + 1, animated: true)
                pageView?.frame = view.bounds.offsetBy(dx: view.bounds.width, dy: 0)
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState) {
                    self.pageView?.frame = self.view.bounds
                    oldPage?.frame = self.view.bounds.offsetBy(dx: -self.view.bounds.width, dy: 0)
                } completion: { _ in
                    oldPage?.removeFromSuperview()
                }
            } else {
                print("is last page")
            }
        default:
            print("toggle control")
        }
    }
}
