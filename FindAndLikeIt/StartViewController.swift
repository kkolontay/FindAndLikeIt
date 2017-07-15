//
//  StartViewController.swift
//  FindAndLikeIt
//
//  Created by kkolontay on 7/15/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import CoreLocation
import RxSwift

class StartViewController: UIViewController {

  @IBOutlet weak var cityNameTextField: UITextField!
  var destination: CLPlacemark?
  var departure:CLPlacemark?
  var subject: Disposable?
  var subjectDeparture: Disposable?
  var activityIndicator: UIActivityIndicatorView?
  
  override func viewDidLoad() {
        super.viewDidLoad()
              // Do any additional setup after loading the view.
    }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if AccessToken.current == nil {
      performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    subjectDeparture = LocationManager.sharedInstance.departurePoint.subscribe(onNext: { element in
      guard let element = element else {
        return
      }
      self.departure = element
    })
    resubscribeVariable()
  }
  
  func resubscribeVariable() {
  subject = LocationManager.sharedInstance.placeMark.subscribe(onNext: { element in
  self.stopActivityIndicator()
    if element != nil {
      self.destination = element
  self.performSegue(withIdentifier: "toMap", sender: nil)
    } else {
      self.addAlarmAlert("Nothing founded.")
    }
  })
  }
  
  func startActivityIndicator() {
   activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
    activityIndicator?.activityIndicatorViewStyle = .gray
    activityIndicator?.backgroundColor = view.backgroundColor
    activityIndicator?.startAnimating()
    activityIndicator?.center = view.center
    view.addSubview(activityIndicator!)
  }
  
  func stopActivityIndicator() {
    if activityIndicator != nil {
      activityIndicator?.removeFromSuperview()
      activityIndicator = nil
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    subject?.dispose()
    subjectDeparture?.dispose()
  }
  
  @IBAction func letsGoButtonPressed(_ sender: Any) {
    if (cityNameTextField.text?.characters.count)! < 2 {
      addAlarmAlert("Your city's name wrong, please be careful.")
      return
    }
    startActivityIndicator()
    LocationManager.sharedInstance.getPlacemark(cityNameTextField.text!)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "toMap" {
        let controller = segue.destination as! MapViewController
        controller.destinationPoint = destination
        controller.departurePoint = departure
      }
    }
}
