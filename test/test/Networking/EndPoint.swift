//
//  EndPoint.swift
//  test
//
//  Created by Daniel Klinkert Houfer on 8/24/17.
//  Copyright © 2017 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import CoreLocation

protocol APIEndpoint {
    var baseUrl:URL { get }
    var path: String { get }
    var method:HTTPMethod { get }
    var parameters:[String:Any]? { get }
    var parameterEncoding: ParameterEncoding { get }
    var customHeaders: [String:String]? { get }
}

extension APIEndpoint {
    var url:URL {
        return baseUrl.appendingPathComponent(path)
    }
}

enum EndPoint {
    
    case login(email:String,password:String)
    case getRequest()
    
    
}


extension EndPoint:APIEndpoint {
  

    var baseUrl:URL {
        switch  self {
        default:
            return URL(string: "http://www.mocky.io/v2/")!
        }
    }
    
    var path:String {
        switch self {
            
        case .login(email: _, password: _):
            return "/sessions"
        case .getRequest():
            return "599f5e8c2c0000710151d4dd"
        }
    }
    
        var method: HTTPMethod {
            switch self {
            default:
                return .get
            }
        }
        
        var parameters:[String:Any]? {
            
            switch self {
            case .login(email: let email, password: let password):
                return ["email":email,"password":password]
            case .getRequest():
                return nil
            }

        }
        
        var customHeaders:[String:String]? {
            let pre = NSLocale.preferredLanguages[0]
            switch self {
            case .login(email: _, password: _):
                return nil
            default:
                return nil
                guard let user = User.currentUser else {
                    return [:]
                }
                return ["Authorization": "Bearer \(user.token)","Content-Type":"application/json","Accept-Language":pre]
            }
        }
        
        var parameterEncoding:ParameterEncoding {
            
            switch self {
            default:
                return JSONEncoding.default
            }
        }
}
