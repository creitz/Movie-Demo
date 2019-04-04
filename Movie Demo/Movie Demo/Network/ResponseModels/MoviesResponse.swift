//
//  MoviesResponse.swift
//  Movie Demo
//
//  Created by Charles Reitz on 3/31/19.
//

import Foundation
import ObjectMapper

class MoviesResponse : Mappable {
    
    var page         = 1
    var totalResults = 0
    var totalPages   = 0
    var movies       = [Movie]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        page         <- map["page"]
        totalResults <- map["total_results"]
        totalPages   <- map["total_pages"]
        movies       <- map["results"]
    }
}
