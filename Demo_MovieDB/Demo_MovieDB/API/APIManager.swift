//
//  APIManager.swift
//  Demo_Story_App
//
//  Created by Apple on 11/27/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Alamofire

enum APIManager {
 
    case movieList
    case searchMovie
    case favoriteMovie
}

extension APIManager {
    
    var baseURL: String { return "https://api.themoviedb.org/3/" }
    
    //MARK: - URL
    
    var url: String {
        
        var path = ""

        switch self {
        case .movieList:
            path = "movie/popular"
        case .searchMovie:
            path = "search/movie"
        case .favoriteMovie:
            path = "account/favorite/movies"
        }
        return baseURL + path
    }
    
    //MARK: - METHOD
    
    var method: HTTPMethod {
        
        switch self {
        case .movieList:
            return .get
        case .searchMovie:
            return .get
        case .favoriteMovie:
            return .post
        }
    }
        
    //MARK: - ENCODING
    
    var encoding: ParameterEncoding {
        
        switch self {
        case .movieList:
            return URLEncoding.default
        case .searchMovie:
            return URLEncoding.default
        case .favoriteMovie:
            return JSONEncoding.default
        }
        
    }
    
    //MARK: - HEADER
    
    var header: [String : String]? {
        
        switch self {
        case .movieList:
            return [:]
        case .searchMovie:
            return [:]
        case .favoriteMovie:
            return [Header.contentType : " "]
        }
    }
}













