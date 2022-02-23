//
//  BaseReusableView.swift
//  Lecture 3
//
//  Created by Tamta Topuria on 11/3/20.
//

import UIKit

class BaseReusableView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    var nibName: String{
        return String(describing: Self.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle(for: BaseReusableView.self)
        bundle.loadNibNamed(nibName, owner: self, options: nil)
        
        guard let contentView = contentView else {fatalError("contentView not set! In:" + nibName)}
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(contentView)
        setup()
    }
    
    func setup(){
        
    }
}
