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
    case movieDetail
    case addFavoriteMovie
    case getToken
    case login
    case sessionId
    case account
    case getFavoriteMovie
    case getPeople
    case getGenres
    case getVideos
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
        case .addFavoriteMovie:
            path = "account/\(Parameter.accountId)/favorite?api_key=\(APIKeyword.api_key)&session_id=\(Parameter.sessionId)"
        case .movieDetail:
            path = ""
        case .getToken:
            path = "authentication/token/new"
        case .login:
            path = "authentication/token/validate_with_login"
        case .sessionId:
            path = "authentication/session/new"
        case .account:
            path = "account"
        case .getFavoriteMovie:
            path = "account/\(Parameter.accountId)/favorite/movies"
        case .getPeople:
            path = "person/popular"
        case .getGenres:
            path = "genre/movie/list"
        case .getVideos:
            path = ""
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
        case .addFavoriteMovie:
            return .post
        case .movieDetail:
            return .get
        case .getToken:
            return .get
        case .login:
            return .get
        case .sessionId:
            return .get
        case .account:
            return .get
        case .getFavoriteMovie:
            return .get
        case .getPeople:
            return .get
        case .getGenres:
            return .get
        case .getVideos:
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
        case .addFavoriteMovie:
            return JSONEncoding.default
        case .movieDetail:
            return URLEncoding.default
        case .getToken:
            return URLEncoding.default
        case .login:
            return URLEncoding.default
        case .sessionId:
            return URLEncoding.default
        case .account:
            return URLEncoding.default
        case .getFavoriteMovie:
            return URLEncoding.default
        case .getPeople:
            return URLEncoding.default
        case .getGenres:
            return URLEncoding.default
        case .getVideos:
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
        case .addFavoriteMovie:
            return [Header.contentType : Header.Content.application]
        case .movieDetail:
            return [:]
        case .getToken:
            return [:]
        case .login:
            return [:]
        case .sessionId:
            return [:]
        case .account:
            return [:]
        case .getFavoriteMovie:
            return [:]
        case .getPeople:
            return [:]
        case .getGenres:
            return [:]
        case .getVideos:
            return [:]
        }
    }
    
}













