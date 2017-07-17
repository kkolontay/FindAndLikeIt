//
//  AppDelegate.swift
//  FindAndLikeIt
//
//  Created by kkolontay on 7/14/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FacebookLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    if let facebook =  FBSDKApplicationDelegate.sharedInstance() {
      facebook.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    return true
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    LocationManager.sharedInstance.stopUpdatingLocation()
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    FBSDKAppEvents.activateApp()
    LocationManager.sharedInstance.startUpdatingLocation()
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
  }
}

