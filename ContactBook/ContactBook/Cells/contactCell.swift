//
//  contactCell.swift
//  ContactBook
//
//  Created by Tamta Topuria on 1/7/21.
//

import UIKit

class contactCell: UICollectionViewCell {
    @IBOutlet var initials: UILabel!
    @IBOutlet var phoneNumber: UILabel!
    @IBOutlet var name: UILabel!
    
    @IBOutlet var view: UIView!
    @IBOutlet var circle: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        circle.layer.cornerRadius = circle.layer.frame.height / 2
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.layer.cornerRadius = 15

    }

}
