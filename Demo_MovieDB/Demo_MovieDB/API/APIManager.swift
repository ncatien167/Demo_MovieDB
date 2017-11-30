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
        }
    }
        
    //MARK: - ENCODING
    
    var encoding: ParameterEncoding {
        
        switch self {
        case .movieList:
            return URLEncoding.default
        case .searchMovie:
            return URLEncoding.default
        }
        
    }
    
    //MARK: - HEADER
    
    var header: [String : String]? {
        
        switch self {
        case .movieList:
            return [:]
        case .searchMovie:
            return [:]
        }
    }
}













