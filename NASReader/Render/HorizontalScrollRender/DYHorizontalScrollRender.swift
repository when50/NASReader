//
//  DQHorizontalScrollRender.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/4.
//

import UIKit

class DYHorizontalScrollRender: UIViewController, DYRenderProtocol {
    struct ConstValue {
        static let scrollTapRange = 0.3
    }
    
    var coverStyle = false {
        didSet {
            updatePages()
        }
    }
    var dataSource: DYRenderDataSource?
    var delegate: DYRenderDelegate?
    var tapFeatureArea: (() -> Void)?
    private var showPageBlock: (() -> Void)?
    private var pageView: UIView?
    
    func showPage(animated: Bool = false) {
        if let page = dataSource?.getCurrentPage() {
            page.frame = view.bounds
            page.backgroundColor = .yellow
            page.layer.shadowColor = UIColor.black.cgColor
            page.layer.shadowOpacity = coverStyle ? 1 : 0
            page.layer.shadowOffset = .zero
            page.layer.shadowRadius = 10
            
            view.addSubview(page)
            pageView = page
        }
    }
    
    private func updatePages() {
        view.subviews.forEach { page in
            page.layer.shadowColor = UIColor.black.cgColor
            page.layer.shadowOpacity = coverStyle ? 1 : 0
            page.layer.shadowOffset = .zero
            page.layer.shadowRadius = 10
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
        guard let delegate = delegate else { return }
        let location = sender.location(in: sender.view)
        let scaledLocation = location.x / view.frame.width
        switch scaledLocation {
        case let v where v < ConstValue.scrollTapRange:
            print("scroll backwards")
            if delegate.switchPrevPage() {
                let oldPage = pageView
                showPage(animated: true)
                pageView?.frame = view.bounds.offsetBy(dx: -view.bounds.width, dy: 0)
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState) {
                    self.pageView?.frame = self.view.bounds
                    if !self.coverStyle {
                        oldPage?.frame = self.view.bounds.offsetBy(dx: self.view.bounds.width, dy: 0)
                    }
                } completion: { _ in
                    oldPage?.removeFromSuperview()
                }

            } else {
                print("is first page")
            }
        case let v where v + ConstValue.scrollTapRange > 1.0:
            print("scroll forward")
            if delegate.switchNextPage() {
                let oldPage = pageView
                showPage(animated: true)
                if !self.coverStyle {
                    pageView?.frame = view.bounds.offsetBy(dx: view.bounds.width, dy: 0)
                }
                if let oldPage = oldPage, coverStyle {
                    view.bringSubviewToFront(oldPage)
                }
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState) {
                    if !self.coverStyle {
                        self.pageView?.frame = self.view.bounds
                    }
                    oldPage?.frame = self.view.bounds.offsetBy(dx: -self.view.bounds.width, dy: 0)
                } completion: { _ in
                    oldPage?.removeFromSuperview()
                }
            } else {
                print("is last page")
            }
        default:
            print("toggle control")
            tapFeatureArea?()
        }
    }
}
