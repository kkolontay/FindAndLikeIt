//
//  MapViewController.swift
//  FindAndLikeIt
//
//  Created by kkolontay on 7/15/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit
import FacebookCore

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    _ =  LocationManager.sharedInstance
        // Do any additional setup after loading the view.
    }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if  AccessToken.current == nil {
      performSegue(withIdentifier: "unwindToLogin", sender: self)
      }
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
