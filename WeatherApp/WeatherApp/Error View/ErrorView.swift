//
//  ErrorView.swift
//  WeatherApp
//
//  Created by Tamta Topuria on 2/2/21.
//

import UIKit

protocol ErrorViewDelegate {
    func errorViewDelegateDidClickReload()
}

class ErrorView: BaseReusableView {
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var errorButton: UIButton!
    
    var delegate: ErrorViewDelegate!
    
    override func awakeFromNib() {
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.numberOfLines = 0
    }
    
    func handleError(error: Error) {
        if let customError = error as? ClassError {
            errorLabel.text = customError.rawValue
        }
        if let customError = error as? ServiceError {
            errorLabel.text = customError.rawValue
        }
    }
    
    @IBAction func reloadClicked(){
        delegate.errorViewDelegateDidClickReload()
    }
    
}
