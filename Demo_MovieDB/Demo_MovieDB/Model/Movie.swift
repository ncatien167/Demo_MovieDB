//
//  Movie.swift
//  Demo_MovieDB
//
//  Created by Apple on 11/30/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit
import SwiftyJSON

class Movie: NSObject {
    var vote_count: Int!
    var id: Int!
    var vote_average: Double!
    var title: String!
    var poster_path: String!
    var original_language: String!
    var original_title: String!
    var genre_ids: Array<Any>!
    var backdrop_path: String!
    var overview: String!
    var release_date: String!
    var revenue: Double!
    var runtime: Int!
    var budget: Double!
    
    init(with response: [String : Any]) {
        vote_count          = response["vote_count"] as? Int ?? -1
        id                  = response["id"] as? Int ?? -1
        vote_average        = response["vote_average"] as? Double ?? -1
        title               = response["title"] as? String ?? ""
        poster_path         = response["poster_path"] as? String ?? ""
        original_language   = response["original_language"] as? String ?? ""
        original_title      = response["original_title"] as? String ?? ""
        genre_ids           = response["genre_ids"] as? Array<Any> ?? []
        backdrop_path       = response["backdrop_path"] as? String ?? ""
        overview            = response["overview"] as? String ?? ""
        release_date        = response["release_date"] as? String ?? ""
        revenue             = response["revenue"] as? Double ?? -1
        runtime             = response["runtime"] as? Int ?? -1
        budget              = response["budget"] as? Double ?? -1
    }
    
    init(responseId: Dictionary<String, Any>) {
        vote_count          = responseId["vote_count"] as? Int ?? -1
        id                  = responseId["id"] as? Int ?? -1
        vote_average        = responseId["vote_average"] as? Double ?? -1
        title               = responseId["title"] as? String ?? ""
        poster_path         = responseId["poster_path"] as? String ?? ""
        original_language   = responseId["original_language"] as? String ?? ""
        original_title      = responseId["original_title"] as? String ?? ""
        genre_ids           = responseId["genres"] as? Array<Any> ?? []
        backdrop_path       = responseId["backdrop_path"] as? String ?? ""
        overview            = responseId["overview"] as? String ?? ""
        release_date        = responseId["release_date"] as? String ?? ""
        revenue             = responseId["revenue"] as? Double ?? -1
        runtime             = responseId["runtime"] as? Int ?? -1
        budget              = responseId["budget"] as? Double ?? -1

    }
    
    struct Genres {
        var id: Int!
        var name: String!
        
        init(with response: [String : Any]) {
            id = response["id"] as? Int ?? -1
            name = response["name"] as? String ?? ""
        }
    }
    
    struct Video {
        var key: String!
        var name: String!
        
        init(with response: [String : Any]) {
            key = response["key"] as? String ?? ""
            name = response["name"] as? String ?? ""
        }
    }
    
}

class People: NSObject {
    var id: Int!
    var profile_path: String!
    var name: String!
    
    init(with response: Dictionary<String, Any>) {
        id = response["id"] as? Int ?? -1
        profile_path = response["profile_path"] as? String ?? ""
        name = response["name"] as? String ?? ""
    }
}






