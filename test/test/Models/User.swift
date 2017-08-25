//
//  User.swift
//  test
//
//  Created by Daniel Klinkert Houfer on 8/24/17.
//  Copyright © 2017 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class User: Object, Mappable {
    
    dynamic var uuid    = ""
    dynamic var token   = ""
    dynamic var type    = ""
    dynamic var email   = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
    }
    
    class var isLoggedIn:Bool  {
        return (currentUser != nil)
    }
    
    class var currentUser:User? {
        var user:User? = nil
        Realm.update { (realm) in
            user = realm.objects(User.self).first
        }
        
        return user
    }
    
    class var isAdmin: Bool {
        guard let current = currentUser else {
            return false
        }
        
        return current.type == "Admin"
    }
    
    
}
