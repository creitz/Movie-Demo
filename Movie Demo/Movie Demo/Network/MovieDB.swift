//
//  MovieDB.swift
//  Movie Demo
//
//  Created by Charles Reitz on 3/31/19.
//

import Foundation
import ObjectMapper

class MovieDB {
    
    private let MOVIE_API_URL = "https://api.themoviedb.org/3"
    
    static let IMAGE_BASE_URL         = "https://image.tmdb.org/t/p/"
    static let MOVIE_POSTER_SMALL_URL = IMAGE_BASE_URL + "w92"
    static let MOVIE_POST_LARGE_URL   = IMAGE_BASE_URL + "original"
    
    static let sInstance = MovieDB()
    
    typealias MOVIE_COMPLETION = ((NetworkResponse, [Movie])->())
    
    private init() {}
    
    func getPopularMovies(_ completion :MOVIE_COMPLETION?) {
        
        EntityManager.movie.dropAll()
        
        let params = ["page" : String(1)]
        get(uri: "/movie/popular", parameters: params) { (response) in
            self.handleMoviesResponse(response, completion: { (resp, movies) in
                if resp.success() {
                    CoreDataUtils.save()
                }
                completion?(response, movies)
            })
        }
    }
    
    func searchMovies(query :String, _ completion :MOVIE_COMPLETION?) {
        
        let params = [
            "page" : String(1),
            "include_adult" : String(false),
            "query" : query
        ]
        get(uri: "/search/movie", parameters: params) { (response) in
            self.handleMoviesResponse(response, completion: completion)
        }
    }
    
    func getDetailsForMovie(id :String, completion :((NetworkResponse, MovieDetails?)->())?) {
        
        let params = [String : String]()
        EntityManager.movieDetails.delete(id: id)
        get(uri: "/movie/\(id)", parameters: params) { (response) in
            
            var movieDetails :MovieDetails?
            
            if response.success(), let json = response.jsonResponse {
                movieDetails = MovieDetails(JSON: json)
                movieDetails?.id = id
                CoreDataUtils.save()
            }
            
            completion?(response, movieDetails)
        }
    }
    
    private func handleMoviesResponse(_ response :NetworkResponse, completion :MOVIE_COMPLETION?) {
        
        var movies = [Movie]()
        
        if response.success() {
            if let json = response.jsonResponse, let moviesResponse = MoviesResponse(JSON: json) {
                movies = moviesResponse.movies
            }
        }
        
        completion?(response, movies)
    }
    
    private func get(uri :String, parameters: [String : String], completion :RESPONSE_BLOCK?) {
        
        var params = parameters
        params["api_key"] = String.Auth.Movie.API_KEY
        
        RequestHelper.request(url: MOVIE_API_URL + uri, params: params, method: .get, completion: completion)
    }
}
