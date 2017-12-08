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
    
    init(with response: JSON) {
        id = JSON(response["id"]).intValue
        title = JSON(response["title"]).stringValue
        runtime = JSON(response["runtime"]).intValue
        budget = JSON(response["budget"]).doubleValue
        revenue = JSON(response["revenue"]).doubleValue
        overview = JSON(response["overview"]).stringValue
        vote_count = JSON(response["vote_count"]).intValue
        genre_ids = JSON(response["genre_ids"]).arrayObject
        poster_path = JSON(response["poster_path"]).stringValue
        release_date = JSON(response["release_date"]).stringValue
        vote_average = JSON(response["vote_average"]).doubleValue
        backdrop_path = JSON(response["backdrop_path"]).stringValue
        original_title = JSON(response["original_title"]).stringValue
        original_language = JSON(response["original_language"]).stringValue
    }
    
    init(responseId: JSON) {
        id = JSON(responseId["id"]).intValue
        title = JSON(responseId["title"]).stringValue
        runtime = JSON(responseId["runtime"]).intValue
        budget = JSON(responseId["budget"]).doubleValue
        revenue = JSON(responseId["revenue"]).doubleValue
        overview = JSON(responseId["overview"]).stringValue
        vote_count = JSON(responseId["vote_count"]).intValue
        genre_ids = JSON(responseId["genres"]).arrayObject
        poster_path = JSON(responseId["poster_path"]).stringValue
        release_date = JSON(responseId["release_date"]).stringValue
        vote_average = JSON(responseId["vote_average"]).doubleValue
        backdrop_path = JSON(responseId["backdrop_path"]).stringValue
        original_title = JSON(responseId["original_title"]).stringValue
        original_language = JSON(responseId["original_language"]).stringValue
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






