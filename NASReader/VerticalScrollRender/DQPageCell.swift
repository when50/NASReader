//
//  DQPageCell.swift
//  NASReader
//
//  Created by oneko.c on 2022/7/3.
//

import UIKit

class DQPageCell: UITableViewCell {
    var page: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            
            if let page = page {
                self.contentView.addSubview(page)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
