//
//  APIKeyswords.swift
//  Demo_Story_App
//
//  Created by Apple on 11/27/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

struct APIKeyword {
    
    static let error        = "errors"
    static let apiKey       = "api_key"
    static let imageUrl     = "https://image.tmdb.org/t/p/w500"
    
    struct Movie {
        
        static let movieId = "movie_id"
        static let page = "page"
        static let language = "language"
        
    }
    
    

}

struct Header {
    
    static let authorization        = "Authorization"
    static let contentType          = "Content-Type"
    
    struct Content {
        static let application      = "application/json"
    }
    
}









