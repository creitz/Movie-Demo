//
//  Movie.swift
//  Movie Demo
//
//  Created by Charles Reitz on 3/31/19.
//

import Foundation
import ObjectMapper
import CoreData

@objc(Movie)
class Movie : NSManagedObject, Mappable {
    
    static let ENTITY_NAME = "Movie"
    
    static let dateFormatter = DateFormatter.defaultFormatter(format: "yyyy-MM-dd")
    
    static let dateTransform :TransformOf<Date, String> = {
        return Transforms.time(formatter: dateFormatter)
    }()
    
    @NSManaged var id               :String?
    @NSManaged var voteAverage      :Double
    @NSManaged var title            :String?
    @NSManaged var posterPath       :String?
    @NSManaged var overview         :String?
    @NSManaged var releaseDate      :Date?
    
    var movieDetails :MovieDetails?
    
    var posterURL :URL? {
        
        guard let posterPath = posterPath else {
            return nil
        }
        
        return URL(string: MovieDB.MOVIE_POSTER_SMALL_URL + posterPath)
    }
    
    var posterURLLarge :URL? {
        
        guard let posterPath = posterPath else {
            return nil
        }
        
        return URL(string: MovieDB.MOVIE_POST_LARGE_URL + posterPath)
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: CoreDataUtils.getManagedObjectContext())
    }

    required init?(map: Map) {
        
        let ctx = CoreDataUtils.getManagedObjectContext()
        let entity = NSEntityDescription.entity(forEntityName: Movie.ENTITY_NAME, in: ctx)
        super.init(entity: entity!, insertInto: ctx)
        
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id               <- (map["id"], Transforms.id)
        voteAverage      <- map["vote_average"]
        title            <- map["title"]
        posterPath       <- map["poster_path"]
        overview         <- map["overview"]
        releaseDate      <- (map["release_date"], Movie.dateTransform)
    }

}

