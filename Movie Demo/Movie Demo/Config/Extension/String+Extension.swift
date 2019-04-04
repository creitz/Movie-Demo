//
//  String+Extension.swift
//  Movie Demo
//
//  Created by Charles Reitz on 4/2/19.
//

import Foundation

protocol Localizable {
    var localized: String { get }
}

extension String : Localizable {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
}
