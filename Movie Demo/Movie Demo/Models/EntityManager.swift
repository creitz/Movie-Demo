//
//  MovieStore.swift
//  Movie Demo
//
//  Created by Charles Reitz on 4/3/19.
//

import Foundation
import UIKit
import CoreData

class EntityManager {
    
    static let movie = EntityManager(entityName: Movie.ENTITY_NAME)
    static let movieDetails = EntityManager(entityName: MovieDetails.ENTITY_NAME)
    
    private var entityName :String!
    
    init(entityName name :String) {
        self.entityName = name
    }
    
    func dropAll() {
        
        let context = CoreDataUtils.getManagedObjectContext()

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.includesPropertyValues = false

        context.performAndWait {
            do {
                
                if let items = try context.fetch(fetchRequest) as? [NSManagedObject] {
                
                    for item in items {
                        context.delete(item)
                    }
                
                    CoreDataUtils.save()
                }
            } catch let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
        }
    }
    
    func delete(id :String) {
        
        let context = CoreDataUtils.getManagedObjectContext()

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        context.performAndWait {
            do {
                
                if let items = try context.fetch(fetchRequest) as? [NSManagedObject] {
                    
                    for item in items {
                        context.delete(item)
                    }
                    
                    CoreDataUtils.save()
                }
            } catch let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
        }
    }
    
    func get(id :String) -> [NSManagedObject]? {
        
        let context = CoreDataUtils.getManagedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            return try context.fetch(fetchRequest) as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
          
        return nil
    }
    
    func load() -> [NSManagedObject]? {

        let context = CoreDataUtils.getManagedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.entityName)
        
        var objs :[NSManagedObject]?
        do {
            objs = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return objs
    }
    
}
