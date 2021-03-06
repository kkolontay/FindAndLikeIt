//
//  FacebookInteraction.swift
//  FindAndLikeIt
//
//  Created by kkolontay on 7/14/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit
import RxSwift
import MapKit
import FacebookCore


class FacebookInteraction: NSObject {
  
  var annotationView: MKAnnotationView?
  var object = BehaviorSubject<String>(value: "Hello")
  
  static var  sharedInstance: FacebookInteraction {
    struct Static {
      static let instance = FacebookInteraction()
    }
    return   Static.instance
  }
  
  private override init() {
    super.init()
  }
  
  func searchOject(_ annotation: MKAnnotationView) {
    annotationView = annotation
    let latitude = annotation.annotation?.coordinate.latitude
    let longitude = annotation.annotation?.coordinate.longitude
    let connection = GraphRequestConnection()
    let request =  "/search?q=restaurant&type=place&center=\(String(describing: latitude!)),\(String(describing: longitude!))&distance=130"
    print(request)
    connection.add(GraphRequest(graphPath: request)) { httpResponse, result in
      switch result {
      case .success(let response):
        print("Graph Request Succeeded: \(response)")
        if let dictionary = response.dictionaryValue {
          if let arrayId: Array<Dictionary<String, Any>> = dictionary["data"] as? Array<Dictionary<String, Any>> {
            if let id: String = (arrayId.first)?["id"] as? String {
              print(id)
              self.getLikes(id)
            }
          }
        }
      case .failed(let error):
        print("Graph Request Failed: \(error)")
      }
    }
    connection.start()
  }
  
  func getLikes(_ id: String ) {
    let request = "/\(id)/likes"
    let connection = GraphRequest(graphPath: request, parameters: [:], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!, apiVersion: .defaultVersion)
    connection.start({
      httpResponse, result in
      switch result {
      case .success(let response):
        print("Count likes: \(response)")
        if let dictionary = response.dictionaryValue {
          print(dictionary)
          if let arrayId: Array<Dictionary<String, Any>> = dictionary["data"] as? Array<Dictionary<String, Any>> {
            DispatchQueue.main.async {
              if  let annotation =  self.annotationView?.annotation as? MKPointAnnotation {
                annotation.subtitle = "\(arrayId.count) likes"
                self.object.onNext("Stop")
              }
            }
          }
        }
      case .failed(let error):
        print("Graph Request Failed: \(error)")
      }
    })
  }
}
