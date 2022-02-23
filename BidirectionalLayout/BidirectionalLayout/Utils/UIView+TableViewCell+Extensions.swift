//
//  UIView+Extensions.swift
//  BidirectionalLayout
//
//  Created by Tamta Topuria on 12/18/20.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
}

extension UITableViewCell {
    
    struct Constants {
        static let spacing: CGFloat = 10
        static let itemCountInLine: CGFloat = 2
    }
    
}
