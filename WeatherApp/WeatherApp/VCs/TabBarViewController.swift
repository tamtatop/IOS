//
//  TabBarViewController.swift
//  WeatherApp
//
//  Created by Tamta Topuria on 1/28/21.
//

import UIKit

//protocol TabBarViewControllerDelegate: AnyObject {
//    func tabBarViewDidChooseForecast(for city: String)
//}

class TabBarViewController: UITabBarController {
    
//    var delegate: TabBarViewControllerDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // make unselected icons white
        self.tabBar.unselectedItemTintColor = UIColor.white
        self.tabBar.isTranslucent = false
    }
}

