//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Tamta Topuria on 1/24/21.
//

import UIKit
import CoreData
//import CoreLocation
//protocol AppDelegateFirstRunDelegate {
//    func isfirstRunOfApplication()
//}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let locationManager = CLLocationManager()
    //var delegate: AppDelegateFirstRunDelegate!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        UserDefaults.standard.set(false, forKey: "notFirstRun")
//        if UserDefaults.standard.bool(forKey: "notFirstRun") == false {
////            delegate.isfirstRunOfApplication()
//            locationManager.requestAlwaysAuthorization()
//            UserDefaults.standard.set(true, forKey: "notFirstRun")
//        }
        
//        locationManager.requestWhenInUseAuthorization()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

