//
//  TimeFormatter.swift
//  Movie Demo
//
//  Created by Charles Reitz on 4/1/19.
//

import Foundation

extension DateFormatter {
    
    static func defaultFormatter(format :String) -> DateFormatter {
        let formatter = DateFormatter()
        let loc = Locale(identifier: "en_US_POSIX")
        formatter.locale = loc
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = format
        return formatter
    }
    
    
    func dateFrom(date: Date?) -> String? {
        
        guard let date = date else {
            return nil
        }
        
        return self.string(from: date)
    }
    
}
