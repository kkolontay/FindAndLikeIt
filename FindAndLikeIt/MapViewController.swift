//
//  MapViewController.swift
//  FindAndLikeIt
//
//  Created by kkolontay on 7/15/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit
import FacebookCore
import MapKit
import RxSwift

class MapViewController: UIViewController {
  var destinationPoint: CLPlacemark?
  var departurePoint: CLPlacemark?
  var departureSubject: Disposable?
  var destinationMapItem: MKMapItem?
  
  @IBOutlet weak var mapLocation: MKMapView!
  override func viewDidLoad() {
    super.viewDidLoad()
    destinationMapItem = getMapItem(destinationPoint!)
    // mapLocation.delegate = self
    // _ =  LocationManager.sharedInstance
    // Do any additional setup after loading the view.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if  AccessToken.current == nil {
      performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    departureSubject = LocationManager.sharedInstance.departurePoint.subscribe(onNext: {
      element in
      guard let element = element else { return }
      self.departurePoint = element
      self.calculateDirection(self.departurePoint!)
      
    })
    calculateDirection(departurePoint!)
  }
  
  func calculateDirection(_ placeMark: CLPlacemark) {
    let request = MKDirectionsRequest()
    request.source = getMapItem(placeMark)
    request.destination = destinationMapItem
    request.requestsAlternateRoutes = true
    request.transportType = .automobile
    let directions = MKDirections(request: request)
    directions.calculate(completionHandler: {
      response, error in
      if let routeResponse = response?.routes {
        
      } else if let _ = error {
        self.addAlarmAlert("Direction not available.")
      }
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func getMapItem(_ placemark: CLPlacemark) -> MKMapItem? {
    if let coordinate = placemark.location?.coordinate, let address = placemark.addressDictionary {
      let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: address as? [String : Any]))
      return mapItem
    }
    return nil
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    departureSubject?.dispose()
  }
}

//extension MapViewController:
