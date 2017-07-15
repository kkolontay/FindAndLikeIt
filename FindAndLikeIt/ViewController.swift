//
//  ViewController.swift
//  FindAndLikeIt
//
//  Created by kkolontay on 7/14/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    let loginButton = LoginButton(readPermissions: [.publicProfile])
    loginButton.center = view.center
    view.addSubview(loginButton)
    }
}

extension ViewController: LoginButtonDelegate {
  func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
    switch result {
    case .failed(let error):
      print(error)
    case .cancelled:
      print("User cancelled login.")
    case .success(let grantedPermissions, let declinedPermissions, let accessToken):
      print("Logged in!")
    }
  }
  func loginButtonDidLogOut(_ loginButton: LoginButton) {
    
  }
}
