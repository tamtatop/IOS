//
//  redCell.swift
//  BidirectionalLayout
//
//  Created by Tamta Topuria on 12/18/20.
//

import UIKit

class redCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: Constants.spacing, left: 2 * Constants.spacing, bottom: Constants.spacing, right: 2 * Constants.spacing))
    }
    
}
