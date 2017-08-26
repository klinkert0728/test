//
//  Request.swift
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
import RealReachability

class Request: Object, Mappable {
    
    dynamic var processId       = ""
    dynamic var process         = ""
    dynamic var activityId      = ""
    dynamic var activity        = ""
    dynamic var requestDate     = Date()
    dynamic var employeeName    = ""
    dynamic var beginDate       = Date()
    dynamic var endDate         = Date()
    dynamic var lasVacationOn   = Date()
    dynamic var approved        = false
    dynamic var predefined      = false
            

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        processId       <- map["processId"]
        process         <- map["process"]
        activityId      <- map["activityId"]
        activity        <- map["activity"]
        requestDate     <- (map["requestDate"],DKHDateTransform())
        employeeName    <- map["employee"]
        beginDate       <- (map["beginDate"],DKHDateTransform())
        endDate         <- (map["endDate"],DKHDateTransform())
        lasVacationOn   <- (map["lasVacationOn"],DKHDateTransform())
        approved        <- map["approved"]
        predefined      <- map["predefined"]
        
    }
    
    override class func primaryKey() -> String? {
        return "activityId"
    }
    
    
    class func getRequestFromDataBase(successClosure:@escaping (_ pendingRequest:[Request])->()){
        Realm.update(updateClosure: { (realm) in
            var pending = [Request]()
            if let user = realm.objects(User.self).first, user.type == "Admin" {
                pending = Array(realm.objects(Request.self).sorted(byKeyPath: "requestDate", ascending: false))
            }else {
                pending = Array(realm.objects(Request.self).filter("predefined = \(false)").sorted(byKeyPath: "requestDate", ascending: false))
            }
          
            successClosure(Array(pending))
        })
    }
    
    class func getAllRequest(endPoint:EndPoint,successClosure:@escaping (_ pendingRequest:[Request])->(), errorClosure:@escaping (_ errorMessage:String?)->()) {
        
        let reachibility = RealReachability()
        reachibility.startNotifier()
        if reachibility.currentReachabilityStatus() == .RealStatusNotReachable ||  reachibility.currentReachabilityStatus() == .RealStatusUnknown {
            getRequestFromDataBase(successClosure: successClosure)
        }else {
            getPendingRequest(endPoint: endPoint, successClosure: { (success) in
                getRequestFromDataBase(successClosure: successClosure)
            })
        }
    }
    
    
    class func getPendingRequest(endPoint:EndPoint,successClosure:@escaping (_ success:Bool)->()) {
        
        Alamofire.request(endPoint.url, method: endPoint.method, parameters: endPoint.parameters, encoding: endPoint.parameterEncoding, headers: nil).responseArray { (response:DataResponse<[Request]>) in
            
            if let pendingRequest = response.result.value, response.result.isSuccess {
                
                Realm.update(updateClosure: { (realm) in
                    realm.add(pendingRequest,update:true)
                })
                
                successClosure(true)
            }else {
                successClosure(false)

            }
        }
        
    }

}
