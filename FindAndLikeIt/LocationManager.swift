//
//  LocationManager.swift
//  FindAndLikeIt
//
//  Created by kkolontay on 7/15/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: CLLocationManager {
  
  fileprivate let locationManager = CLLocationManager()
  static var sharedInstance: LocationManager {
      struct MainStruct {
      static let item = LocationManager()
    }
    return MainStruct.item
  }
  
  private override init() {
    super.init()
    delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestAlwaysAuthorization()
    
  }

}
extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
      locationManager.requestLocation()
    }
  }
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
  
}
