//
//  FacebookInteraction.swift
//  FindAndLikeIt
//
//  Created by kkolontay on 7/14/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit
import RxSwift


class FacebookInteraction: NSObject {
  
  static var  sharedInstance: FacebookInteraction {
    struct Static {
      static let instance = FacebookInteraction()
    }
    return   Static.instance
  }
  
  private override init() {
    super.init()
  }
}
