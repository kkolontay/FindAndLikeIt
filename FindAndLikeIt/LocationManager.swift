//
//  LocationManager.swift
//  FindAndLikeIt
//
//  Created by kkolontay on 7/15/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import RxSwift

class LocationManager: CLLocationManager {
  var placeMark = PublishSubject<CLPlacemark?>()
  var departurePoint = PublishSubject<CLPlacemark?>()
  static var sharedInstance: LocationManager {
    struct MainStruct {
      static let item = LocationManager()
    }
    return MainStruct.item
  }
  
  private override init() {
    super.init()
    self.delegate = self
    self.requestWhenInUseAuthorization()
  }
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedWhenInUse:
      self.requestAlwaysAuthorization()
    case .authorizedAlways:
      self.desiredAccuracy = kCLLocationAccuracyHundredMeters
      self.requestLocation()
    // locationManager.delegate = self
    default:
      print("You can't use this app")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    CLGeocoder().reverseGeocodeLocation(locations.last!) {
      placemarks, error -> Void in
      if let placemarks = placemarks {
        let placemark = placemarks.first
        self.departurePoint.onNext(placemark)

      }
    }
  }
  
  func getPlacemark(_ address: String) {
    CLGeocoder().geocodeAddressString(address, completionHandler: {
      placemarks, error in
      if error != nil {
        self.placeMark.onNext(nil)
        return
      }
      if let placemarks = placemarks {
        self.placeMark.onNext(placemarks.first!)
        let coordinate = placemarks.first?.location?.coordinate
        print(String(describing: coordinate))
      } else {
        self.placeMark.onCompleted()
      }
    })
  }
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
  
}
