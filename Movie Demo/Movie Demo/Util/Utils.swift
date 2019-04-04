//
//  Utils.swift
//  Movie Demo
//
//  Created by Charles Reitz on 4/3/19.
//

import Foundation
import CoreData
import UIKit

class CoreDataUtils {
    
    static func getManagedObjectContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    }
    
    static func save() {
        (UIApplication.shared.delegate as? AppDelegate)!.saveContext()
    }
}
