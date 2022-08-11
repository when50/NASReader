//
//  DYReaderNavigationView.swift
//  NASReader
//
//  Created by oneko on 2022/7/8.
//

import UIKit

protocol DYReaderNavigationViewDelegate: AnyObject {
    func navigationViewTapBack(_ view: DYReaderNavigationView)
}

class DYReaderNavigationView: UIView {
    weak var delegate: DYReaderNavigationViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        
        let backBtn = UIButton(type: .system)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.setImage(UIImage.icon(withName: backBtnName, fontSize: 17.6, color: .black), for: .normal)
        backBtn.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        addSubview(backBtn)
        addConstraint(NSLayoutConstraint(item: backBtn, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 20))
        addConstraint(NSLayoutConstraint(item: backBtn, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -7))
    }
    
    @objc
    private func handleTap(_ sender: UIButton) {
        delegate?.navigationViewTapBack(self)
    }

}

extension DYReaderNavigationView {
    struct Assets {
        static let backBtnName = "图标-返回"
    }
    
    var backBtnName: String {
        return Assets.backBtnName
    }
}
