//
//  DYGestureView.swift
//  NASReader
//
//  Created by oneko.c on 2022/8/2.
//

import UIKit

enum DYGestureViewOperation {
    case scrollBackword
    case scrollForward
    case toggleNavigationFeautre
}

protocol DYGestureViewDelegate: AnyObject {
    func gestureView(_ gestureView: DYGestureView, didTap operation: DYGestureViewOperation)
}

final class DYGestureView: UIView {

    weak var delegate: DYGestureViewDelegate?
    
    struct ConstValue {
        static let scrollTapRange = 0.3
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func handleTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        let scaledLocation = location.x / frame.width
        switch scaledLocation {
        case let v where v < ConstValue.scrollTapRange:
            print("scroll backward")
            delegate?.gestureView(self, didTap: .scrollBackword)
        case let v where v + ConstValue.scrollTapRange > 1.0:
            print("scroll forward")
            delegate?.gestureView(self, didTap: .scrollForward)
        default:
            print("toggle control")
            delegate?.gestureView(self, didTap: .toggleNavigationFeautre)
        }
    }

}
