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
    loginButton.delegate = self
    loginButton.center = view.center
    view.addSubview(loginButton)
  }
  
  @IBAction func unwind(segue: UIStoryboardSegue) {}
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if AccessToken.current != nil {
      performSegue(withIdentifier: "start", sender: nil)
    }
  }
}

extension ViewController: LoginButtonDelegate {
  
  func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
    switch result {
    case .failed(let error):
      addAlarmAlert(error.localizedDescription)
      print(error)
    case .cancelled:
      addAlarmAlert("You cancelled your operation.")
      print("User cancelled login.")
    case .success( _, _, _):
      performSegue(withIdentifier: "start", sender: nil)
      print("Logged in!")
    }
  }
  
  func loginButtonDidLogOut(_ loginButton: LoginButton) {
    addAlarmAlert("You log out, bye.")
  }
}
