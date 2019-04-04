//
//  Int+Extensions.swift
//  Movie Demo
//
//  Created by Charles Reitz on 4/3/19.
//

import Foundation

extension Int {
    
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
}
