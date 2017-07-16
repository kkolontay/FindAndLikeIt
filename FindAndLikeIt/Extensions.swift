//
//  Extensions.swift
//  FindAndLikeIt
//
//  Created by kkolontay on 7/14/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func addAlarmAlert(_ message: String) {
    let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  func startActivityIndicator(_ activityIndicator: inout UIActivityIndicatorView?) {
    activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
    activityIndicator?.activityIndicatorViewStyle = .gray
    activityIndicator?.backgroundColor = view.backgroundColor
    activityIndicator?.startAnimating()
    activityIndicator?.center = view.center
    view.addSubview(activityIndicator!)
  }
  
  func stopActivityIndicator(_  activityIndicator: inout UIActivityIndicatorView?) {
    if activityIndicator != nil {
      activityIndicator?.removeFromSuperview()
      activityIndicator = nil
    }
  }

}
