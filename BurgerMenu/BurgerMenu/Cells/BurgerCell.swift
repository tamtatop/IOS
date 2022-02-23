//
//  BurgerCell.swift
//  BurgerMenu
//
//  Created by Tamta Topuria on 12/10/20.
//

import UIKit

class BurgerCellModel {
    var title: String
    
    init(title: String){
        self.title = title
    }
}

class BurgerCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    
    func configure(with model: BurgerCellModel){
        titleLabel.text = model.title
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: true)
        if highlighted {
            UIView.animate(
                withDuration: 0.15,
                animations: {
                    self.titleLabel.textColor = .orange
                }
            )
        } else {
            UIView.animate(
                withDuration: 0.15,
                delay: 0.9,
                options: .curveLinear,
                animations: {
                    self.titleLabel.textColor = .black
                },
                completion: nil
            )
        }
    }
    
}
