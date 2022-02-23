//
//  AlertViewController.swift
//  WeatherApp
//
//  Created by Tamta Topuria on 2/1/21.
//

import UIKit

protocol AlertViewControllerDelegate {
    func AlertViewControllerdidClickAddButton(with city: String)
}

class AlertViewController: UIViewController {
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var blurredView: UIView!
    @IBOutlet var popupView: UIView!
    @IBOutlet var centerConstraint: NSLayoutConstraint!
    @IBOutlet var errorDistFromTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var errorView: UIView!
    @IBOutlet var errorInfo: UILabel!
    
    var delegate: AlertViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenToKeyBoardNotifications();
        loader.isHidden = true
//        errorView.isHidden = true
        errorInfo.lineBreakMode = .byWordWrapping
        errorInfo.numberOfLines = 0
        errorView.alpha = 0
    }
    
    override func viewDidLayoutSubviews() {
        let gesture = UITapGestureRecognizer(
            target: self,
            action:  #selector (self.clickBlurredView (_:))
        )
        gesture.delegate = self
        blurredView.addGestureRecognizer(gesture)
    }
    
    @IBAction func add(){
        if let city = cityTextField.text {
            addButton.setBackgroundImage(nil, for: .normal)
            loader.isHidden = false
            cityTextField.endEditing(true)
            delegate.AlertViewControllerdidClickAddButton(with: city)
        } else {
            print("Empty TextField")
        }
    }
    
    func handleError(error: Error) {
        DispatchQueue.main.async { [unowned self] in
            if let classError = error as? ClassError {
                errorInfo.text = classError.rawValue
            }
            
            if let serviceError = error as? ServiceError {
                errorInfo.text = serviceError.rawValue
            }
            print(error)
            
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    errorView.alpha = 1
                }
            )
            
            UIView.animate(
                withDuration: 0.5,
                delay: 5,
                options: .curveLinear,
                animations: {
                    errorView.alpha = 0
                },
                completion: nil
            )
            
            loader.stopAnimating()
            addButton.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        }
    }
    
    func listenToKeyBoardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardComesUp(notification:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardGoesDown(notification:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardComesUp(notification: Notification){
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {return}
        let keyBoardHeight = endFrame.cgRectValue.height
        self.centerConstraint.constant = -keyBoardHeight/2
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardGoesDown(notification: Notification){
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else {return}
        self.centerConstraint.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func dismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func clickBlurredView(_ sender: UITapGestureRecognizer){
        dismiss()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismiss()
    }
    
}

extension AlertViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !((touch.view?.isDescendant(of: popupView))!)
    }
}

