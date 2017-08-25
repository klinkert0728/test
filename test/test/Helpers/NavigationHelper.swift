//
//  NavigationHelper.swift
//  test
//
//  Created by Daniel Klinkert Houfer on 8/24/17.
//  Copyright © 2017 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
//
//  DKHNavigation.swift
//  LAFEMME
//
//  Created by Daniel Klinkert Houfer on 4/20/17.
//  Copyright © 2017 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import UIKit

class Navigation {
    
    class func loginNavigationController() -> UINavigationController {
        return   UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginNavigation") as! UINavigationController
    }
    
    class func loginViewController() -> LoginViewController {
        return UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }
    
    
    
    
    
}
