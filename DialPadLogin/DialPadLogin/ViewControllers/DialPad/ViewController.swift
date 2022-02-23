//
//  ViewController.swift
//  DialPadLogin
//
//  Created by Tamta Topuria on 11/22/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var numberLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func presentCallVC(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        if let callVCNav = mainStoryBoard.instantiateViewController(withIdentifier: "CallVCNavigation") as? UINavigationController {
            callVCNav.modalPresentationStyle = .fullScreen //ამიტომ დავწერე კოდით პრეზენტი
            present(callVCNav, animated: true, completion: nil)
        }
    }
    
    @IBAction func dialNumber(button: myButton!){
        if numberLabel.text != nil {
            numberLabel.text! += button.letter!
        } else {
            numberLabel.text = button.letter!
        }
       
//        print(button.letter)
    }
    
    @IBAction func deleteNumber(){
        if numberLabel.text != nil {
            numberLabel.text! = String((numberLabel.text?.dropLast())!)
        }
//        print(numberLabel.text!)
    }
    
    

}

