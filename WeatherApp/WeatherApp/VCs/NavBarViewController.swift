//
//  NavBarViewController.swift
//  WeatherApp
//
//  Created by Tamta Topuria on 1/28/21.
//

import UIKit

class NavBarViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // make unselected icons white
        self.navigationBar.isTranslucent = false
//        print("CHIDRENNNN", self.children)
    }
}
