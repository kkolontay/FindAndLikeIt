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
  var restourants: [MKMapItem] = []
  var locationManager: LocationManager? = LocationManager.sharedInstance
  var polyline:MKPolyline?
  var speed: Disposable?
  var lastSpeed: Double = 0
  
  @IBOutlet weak var mapLocation: MKMapView!
  override func viewDidLoad() {
    super.viewDidLoad()
    destinationMapItem = getMapItem(destinationPoint!)
     mapLocation.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if  AccessToken.current == nil {
      performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    speed = locationManager?.speedLocaton.subscribe(onNext: { element in
      self.lastSpeed = element
    })
    departureSubject = locationManager?.departurePoint.subscribe(onNext: {
      element in
      guard let element = element else { return }
      self.departurePoint = element
      DispatchQueue.global(qos: .default).async {
        self.calculateDirection(self.departurePoint!)
      }
    })
   DispatchQueue.global(qos: .default).async {
      self.calculateDirection(self.departurePoint!)
    }
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
      if let routeResponse: [MKRoute] = response?.routes {
        let quickestRouteForSegment: MKRoute = routeResponse.sorted(by: {
          $0.expectedTravelTime < $1.expectedTravelTime
        }).first!
        self.plotPolyline(route: quickestRouteForSegment)
      } 
    })
    var square: Double = 0.025
    if 9 < lastSpeed {
      square = 0.045
    }
    if 38 < lastSpeed {
      square = 0.065
    }
    if  lastSpeed > 39 {
      square = 0.085
    }
    let span = MKCoordinateSpanMake(square, square)
    let region = MKCoordinateRegion(center: (placeMark.location?.coordinate)!, span: span)
    DispatchQueue.main.sync {
    mapLocation.setRegion(region, animated: true)
    }
    DispatchQueue.global(qos: .background).async {
      self.getRestoranst(placeMark)
    }
  }
  
  func getRestoranst(_ placeMark: CLPlacemark) {
    let request = MKLocalSearchRequest()
    request.naturalLanguageQuery = "restaurant"
    request.region = MKCoordinateRegion(center: (placeMark.location?.coordinate)!, span: MKCoordinateSpanMake(0.05, 0.05))
    let search = MKLocalSearch(request: request)
    search.start(completionHandler: {
      response, error in
      guard let response = response else {
        print("There was an error searching")
        return
      }
       self.mapLocation.removeAnnotations(self.mapLocation.annotations)
      print("There are \(response.mapItems.count)")
      let nearestRestaurant = response.mapItems.sorted { ($0.placemark.location?.distance(from: (self.departurePoint?.location)!))! < ($1.placemark.location?.distance(from: (self.departurePoint?.location)!))!
      }
      self.restourants = Array(nearestRestaurant.prefix(10))
      for item in self.restourants {
        DispatchQueue.main.async {
        self.dropPinZoomIn(placemark: item.placemark)
        }
        item.placemark.region
        print("\(String(describing: item.name)), \(item.placemark)")
        print("latitude ==== \(String(describing: item.placemark.coordinate.latitude))")
      }
    })
  }
//  func parseAddress(selectedItem:MKPlacemark) -> String {
//    // put a space between "4" and "Melrose Place"
//    let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
//    // put a comma between street and city/state
//    let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
//    // put a space between "Washington" and "DC"
//    //let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
//    let addressLine = String(
//      format:"%@%@%@%@%@",
//      // street number
//      selectedItem.subThoroughfare ?? "",
//      firstSpace,
//      // street name
//      selectedItem.thoroughfare ?? "",
//      comma,
//      // city
//      selectedItem.locality ?? ""
//      // state
//     // selectedItem.administrativeArea ?? ""
//    )
//    return addressLine
//  }
  
  func dropPinZoomIn(placemark:MKPlacemark){
    let annotation = MKPointAnnotation()
    annotation.coordinate = placemark.coordinate
    annotation.title = placemark.name
    //MARK - This place
    annotation.subtitle = "0 likes"
    mapLocation.addAnnotation(annotation)
  }
  
  func plotPolyline(route: MKRoute) {
    if polyline != nil {
      mapLocation.remove(polyline!)
    }
    mapLocation.add(route.polyline)
    polyline = route.polyline
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
    locationManager = nil
    speed?.dispose()
  }
}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let polylineRenderer = MKPolylineRenderer(overlay: overlay)
    if (overlay is MKPolyline) {
      polylineRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.75)
      polylineRenderer.lineWidth = 5
    }
    return polylineRenderer
  }
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    FacebookInteraction.sharedInstance.searchOject(view)
  }
}
