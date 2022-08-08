//
//  DQPageCell.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/3.
//

import UIKit

class DYPageTableViewCell: UITableViewCell {
    var page: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            
            if let page = page {
                page.frame = self.bounds
                self.contentView.addSubview(page)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.isOpaque = false
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
