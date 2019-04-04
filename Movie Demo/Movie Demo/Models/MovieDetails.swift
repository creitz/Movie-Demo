//
//  MovieExtras.swift
//  Movie Demo
//
//  Created by Charles Reitz on 4/3/19.
//

import Foundation
import ObjectMapper
import CoreData

@objc(MovieDetails)
class MovieDetails : NSManagedObject, Mappable {
    
    static let ENTITY_NAME = "MovieDetails"
    
    @NSManaged var id       :String?
    @NSManaged var budget   :NSNumber
    @NSManaged var homePage :String?
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: CoreDataUtils.getManagedObjectContext())
    }
    
    required init?(map: Map) {
        
        let ctx = CoreDataUtils.getManagedObjectContext()
        let entity = NSEntityDescription.entity(forEntityName: MovieDetails.ENTITY_NAME, in: ctx)
        super.init(entity: entity!, insertInto: ctx)
        
        mapping(map: map)
    }
    
    func mapping(map: Map) {
    
        budget   <- map["budget"]
        homePage <- map["homepage"]
        id       <- map["id"]
    }
}
