//
//  NetworkResponse.swift
//  Movie Demo
//
//  Created by Charles Reitz on 3/31/19.
//

import Foundation
import Alamofire

class NetworkResponse : NSObject {
    
    var data         :Data?
    var error        :Error?
    var jsonResponse :[String: Any]?
    
    static let ERROR_DOMAIN = "MovieErrorDomain"
    
    private static let NO_CONNECTION_ERROR = NSError(domain: ERROR_DOMAIN, code: -1, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection"])
    
    private static let PARSE_ERROR = NSError(domain: ERROR_DOMAIN, code: -1, userInfo: [NSLocalizedDescriptionKey: "The response from the server could not be parsed"])
    
    static func noConnectionResponse() -> NetworkResponse {
        
        let newResponse = NetworkResponse()
        newResponse.error = NO_CONNECTION_ERROR
        return newResponse
    }
    
    static func make(response: DataResponse<Any>) -> NetworkResponse {
        
        let newResponse = NetworkResponse()
        newResponse.data = response.data
        newResponse.error = response.result.error
        if newResponse.error == nil && newResponse.data != nil {
            if let json = response.result.value as? [String : Any] {
                newResponse.jsonResponse = json
            } else {
                newResponse.error = PARSE_ERROR
            }
        }
        return newResponse
    }
    
    func getError() -> String {
        return getError(defaultMessage: nil)
    }
    
    func getError(defaultMessage :String? = nil) -> String {
        
        if self.error != nil {
            return self.error!.localizedDescription
        } else if self.data == nil || self.data?.count == 0 {
            return "No Response From Server"
        }
        
        return defaultMessage ?? "No Error Message Available."
    }
    
    func success() -> Bool {
        return self.error == nil && self.jsonResponse != nil
    }
}
