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
    static let baseURL              = "https://api.themoviedb.org/3/"
    static let error                = "errors"
    static let apiKey               = "api_key"
    static let imageUrl             = "https://image.tmdb.org/t/p/w500"
    static let api_key              = "ee8cf966d22254270f6faa1948ecf3fc"
    
    struct Movie {
        static let movieId          = "movie_id"
        static let page             = "page"
        static let language         = "language"
        static let account_id       = "account_id"
    }
    
    struct Account {
        static let token            = "request_token"
        static let sessionId        = "session_id"
        static let username         = "username"
        static let password         = "password"
    }

}

struct Header {
    static let authorization        = "Authorization"
    static let contentType          = "Content-Type"
    
    struct Content {
        static let application      = "application/json"
    }
    
}









