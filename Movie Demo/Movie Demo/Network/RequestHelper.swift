//
//  RequestHelper.swift
//  Movie Demo
//
//  Created by Charles Reitz on 3/31/19.
//

import Foundation
import Alamofire

typealias RESPONSE_BLOCK = (NetworkResponse) -> Void

class RequestHelper {
    
    static func request(url :String, params: [String : String], method :HTTPMethod, completion :RESPONSE_BLOCK?) {
        
        if !Reachability.isConnectedToNetwork() {
            completion?(NetworkResponse.noConnectionResponse())
        } else {
            Alamofire.request(url, method: method, parameters: params).responseJSON { response in
                completion?(NetworkResponse.make(response: response))
            }
        }
    }
    
}
