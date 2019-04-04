//
//  DateTransform.swift
//  Movie Demo
//
//  Created by Charles Reitz on 4/1/19.
//

import Foundation
import ObjectMapper

class Transforms {

    static func time(formatter :DateFormatter) -> TransformOf<Date,String> {
        
        return TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
            if let value = value {
                return formatter.date(from: value)
            }
            return nil
        }, toJSON: { (value: Date?) -> String? in
            if let value = value {
                return formatter.dateFrom(date: value)
            }
            return nil
        })
    }
    
    static let id = TransformOf<String, Int>(fromJSON: { (value: Int?) -> String? in
        if let value = value {
            return String(format: "%d", value)
        }
        return nil
    }, toJSON: { (value: String?) -> Int? in
        if let value = value {
            return Int(value)
        }
        return nil
    })
}
