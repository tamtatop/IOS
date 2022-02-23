//
//  LocationProvider.swift
//  WeatherApp
//
//  Created by Tamta Topuria on 2/7/21.
//

import UIKit
import CoreLocation

class LocationProvider: NSObject {
    let locationManager = CLLocationManager()
    
    var completion: ((CLLocation?) -> ())?
    var curLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func enableBasicLocationServices(){
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getLocation(completion: @escaping (CLLocation?) -> ()){
        if CLLocationManager.locationServicesEnabled() {
            self.completion = completion
            locationManager.startUpdatingLocation()
        } else {
            completion(nil)
        }
    }
    
}

extension LocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        completion?(locations[0] as CLLocation)
        self.completion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(nil)
        self.completion = nil
    }
    
}
