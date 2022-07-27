//
//  OutlineItemCell.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/20.
//

import UIKit

class OutlineItemCell: UITableViewCell {
    struct Constant {
        static let currentColor = #colorLiteral(red: 1, green: 0.6965011954, blue: 0, alpha: 1)
        static let cachedColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)
        static let uncachedColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 0.3)
    }
    
    let itemTitleLabel = UILabel()
    var item: OutlineItem?
    var isCurrent = Bindable<Bool>(false)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupBindables()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        itemTitleLabel.font = .systemFont(ofSize: 14.0)
        itemTitleLabel.textColor = Constant.uncachedColor
    }
    
    private func setupBindables() {
        isCurrent.bind { [weak self] isCurrent in
            let normalColor = (self?.item?.cached ?? false) ? Constant.cachedColor : Constant.uncachedColor
            self?.itemTitleLabel.textColor = isCurrent ? Constant.currentColor : normalColor
        }
    }
    
    func setViewModel(item: OutlineItem, isCurrent: Bool) {
        itemTitleLabel.text = item.title
        self.isCurrent.value = isCurrent
    }

}
