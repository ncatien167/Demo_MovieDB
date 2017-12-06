//
//  APIController.swift
//  Demo_Story_App
//
//  Created by Apple on 11/27/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias ErrorResponseBlock = (_ error: String?) -> Void
typealias ResponseBlock = (_ errorResponse: String?, _ json: JSON?) -> Void

struct APIController {
    
    static func request(path: String, params: Parameters? = nil, manager: APIManager, result: @escaping ResponseBlock) {
        let url = APIKeyword.baseURL + path
        Logger.log(message: "URL: \(url)", event: .info)
        
        Alamofire.request(url, method: manager.method, parameters: params, encoding: manager.encoding, headers: manager.header).responseJSON { (responseObject) -> Void in
            print(url)
            switch responseObject.result {
            case .success(let data):
                
                let response = JSON(data)
                result(nil, response)
                Logger.log(message: response.prettyPrinted(), event: .info)
                
            case .failure(let error):
                
                if let data = responseObject.data {
                    
                    guard let json = String(data: data, encoding: .utf8) else { return }
                    let response = JSON(parseJSON: json)
                    
                    guard let message = response[APIKeyword.error].string else {
                        result(error.localizedDescription, nil)
                        return
                    }
                    
                    result(message, nil)
                    Logger.log(message: response.prettyPrinted(), event: .info)
                }
            }
        }
    }
    
    static func request(manager: APIManager, params: Parameters? = nil, result: @escaping ResponseBlock) {
        
        Logger.log(message: "URL: \(manager.url)", event: .info)
        
        Alamofire.request(manager.url, method: manager.method, parameters: params, encoding: manager.encoding, headers: manager.header).responseJSON { (responseObject) -> Void in
            print(manager.url)
            switch responseObject.result {
            case .success(let data):
                
                let response = JSON(data)
                result(nil, response)
                Logger.log(message: response.prettyPrinted(), event: .info)
                
            case .failure(let error):
                
                if let data = responseObject.data {
                
                    guard let json = String(data: data, encoding: .utf8) else { return }
                    let response = JSON(parseJSON: json)
                    
                    guard let message = response[APIKeyword.error].string else {
                        result(error.localizedDescription, nil)
                        return
                    }
                    result(message, nil)
                    Logger.log(message: response.prettyPrinted(), event: .info)
                    
                }
            }
        }
    }
}

// JSON Pretty Printed Extension

extension JSON {
    
    func prettyPrinted() -> String {
        
        guard let dict = self.dictionaryObject, let json = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else { return ""}
        let prettyString = String(data: json, encoding: .utf8)
        
        return prettyString ?? ""
    }
    
}
