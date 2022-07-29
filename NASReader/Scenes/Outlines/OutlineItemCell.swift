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
        static let uncachedColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    let itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = Constant.uncachedColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var item: Bindable<OutlineItem?> = Bindable(nil)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupBindables()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let views = ["titleLabel": itemTitleLabel]
        contentView.addSubview(itemTitleLabel)
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(26)-[titleLabel]-(26)-|", metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(14)-[titleLabel]-(14)-|", metrics: nil, views: views))
    }
    
    private func setupBindables() {
        item.bind { [weak self] value in
            let isCached = value?.cached ?? false
            let isCurrent = value?.isCurrent ?? false
            let normalColor = isCached ? Constant.cachedColor : Constant.uncachedColor
            self?.itemTitleLabel.textColor = isCurrent ? Constant.currentColor : normalColor
            self?.itemTitleLabel.text = value?.title
        }
    }
    
    func setViewModel(item: OutlineItem) {
        self.item.value = item
    }

}
