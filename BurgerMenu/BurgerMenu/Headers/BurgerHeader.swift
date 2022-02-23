//
//  BurgerHeader.swift
//  BurgerMenu
//
//  Created by Tamta Topuria on 12/10/20.
//

import UIKit

class BurgerHeaderModel {
    var isExpanded: Bool
    weak var delegate: BurgerHeaderDelegate?
    
    init(isExpanded: Bool, delegate: BurgerHeaderDelegate?) {
        self.isExpanded = isExpanded
        self.delegate = delegate
    }
}

protocol BurgerHeaderDelegate: AnyObject {
    func burgerHeaderDidClickButton(_ header: BurgerHeader)
}

class BurgerHeader: UITableViewHeaderFooterView {
    @IBOutlet private var button: UIButton!
    
    var model: BurgerHeaderModel!
    var crossImage: UIImage!
    var linesImage: UIImage!
    
    func configure(with model: BurgerHeaderModel){
        self.model = model
        crossImage = UIImage(systemName: "xmark.circle")
        linesImage = UIImage(systemName: "line.horizontal.3")
        crossImage.withTintColor(.orange, renderingMode: .alwaysTemplate)
        button.tintColor = .orange
//        button.invalidateIntrinsicContentSize() მაინც კუმშავს crossImage-ს, ვერ გავასწორე ვერაფრით
        setImageForButton()
    }
    
    func setImageForButton(){
        model.isExpanded
            ? button.setBackgroundImage(crossImage, for: .normal)
            : button.setBackgroundImage(linesImage, for: .normal)
    }
 
    @IBAction func handleButton(){
        if model.isExpanded {
            UIButton.animate(
                withDuration: 0.15,
                delay: 0,
                options: .curveLinear,
                animations: { //ანიმაციაში ჩასმული უფრო ლამაზი გამოვიდა მგონი, ვიდრე ქომფლეშენში
                    self.button.transform = .identity
                    self.button.setBackgroundImage(self.linesImage, for: .normal)
                    self.button.tintColor = .orange
                },
                completion: { _ in
//                    self.button.setBackgroundImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
                })
        } else {
            UIButton.animate(
                withDuration: 0.15,
                delay: 0,
                options: .curveLinear,
                animations: {
                    self.button.transform = CGAffineTransform(rotationAngle: -.pi/2)
                    self.button.setBackgroundImage(self.crossImage, for: .normal)
                },
                completion: { _ in
                    UIView.animate(
                        withDuration: 0.1,
                        delay: 1,
                        options: .curveLinear,
                        animations: {
                            self.button.tintColor = .systemGray2
                        },
                        completion: nil
                    )
//                    self.button.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
                })
        }
        model.isExpanded.toggle()
        model.delegate?.burgerHeaderDidClickButton(self)
    }
}
