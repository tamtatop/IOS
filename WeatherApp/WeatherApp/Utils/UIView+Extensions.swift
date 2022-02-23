//
//  UIView+Extensions.swift
//  WeatherApp
//
//  Created by Tamta Topuria on 2/1/21.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}

