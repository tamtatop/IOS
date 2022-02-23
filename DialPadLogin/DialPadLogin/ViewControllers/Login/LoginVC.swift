//
//  LoginVC.swift
//  DialPadLogin
//
//  Created by Tamta Topuria on 11/23/20.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet var login: UIButton!
    @IBOutlet var signUp: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailView: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var containerViewDistFromTop: NSLayoutConstraint!
    @IBOutlet var containerViewDistFromBottom: NSLayoutConstraint!
    @IBOutlet var eye: UIButton!
    
    override func viewDidLoad() {
        listenToKeyBoardNotifications();
    }
    override func viewDidLayoutSubviews() {
        login.layer.cornerRadius = 20
        signUp.layer.cornerRadius = 20
        emailView.layer.cornerRadius = 20
        passwordView.layer.cornerRadius = 20
        signUp.layer.borderWidth = 1
        signUp.layer.borderColor = UIColor.systemBlue.cgColor
        emailTextField.borderStyle = .none
        passwordTextField.borderStyle = .none
    }
    
    @IBAction func showOrHidePassword(){
        let isHidden = passwordTextField.isSecureTextEntry
        if(isHidden) {
            passwordTextField.isSecureTextEntry = false
            eye.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            eye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
    @IBAction func loginToDialPad(){
       if (emailTextField.text == "test@mail.com" && passwordTextField.text == "1234") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let dialPadVC = storyboard.instantiateViewController(identifier: "TabBarController")
            dialPadVC.modalPresentationStyle = .overFullScreen
            show(dialPadVC, sender: self)

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
        self.containerViewDistFromBottom.constant = keyBoardHeight
        self.containerViewDistFromTop.constant = -keyBoardHeight
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardGoesDown(notification: Notification){
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else {return}
        self.containerViewDistFromBottom.constant = 0
        self.containerViewDistFromTop.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}
