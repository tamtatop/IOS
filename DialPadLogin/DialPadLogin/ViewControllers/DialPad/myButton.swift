//
//  myButton.swift
//  DialPadLogin
//
//  Created by Tamta Topuria on 11/23/20.
//

import UIKit

@IBDesignable class myButton: UIButton {
    
    @IBInspectable var letter: String!
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            initSetup()
        }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    func initSetup(){
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        self.addConstraint(constraint)
        
        self.titleLabel?.numberOfLines = 2
    }
    
    func setColor(){
        if(self.letter == "call") {
            self.backgroundColor = .systemGreen
        } else if (self.letter == "backspace"){
            self.backgroundColor = .white
        } else {
            self.backgroundColor = .systemGray4
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setColor()
        self.layer.cornerRadius = self.bounds.size.width/2
        self.tintColor = UIColor.white
    }
    
    

    
}
