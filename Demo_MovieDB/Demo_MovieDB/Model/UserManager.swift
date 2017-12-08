//
//  UserManager.swift
//  Demo_MovieDB
//
//  Created by Apple on 12/1/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit
import SwiftyJSON

let Token = "Token"
let AccountId = "UserId"
let UserName = "UserName"
let UserSessionId = "UserSessionId"


class UserManager: NSObject {
    
    var createToken: String!
    var request_token: String!
    var guest_session_id: String!
    var id: Int!
    var username: String!
    var sessionId: String!
    
    static let shared = UserManager()
    private override init(){}
    
    init(with response: JSON) {
        createToken      = response["request_token"].stringValue
        guest_session_id = response["guest_session_id"].stringValue
    }
    
    func setToken(with response: JSON) {
        request_token = response["request_token"].stringValue
        
        if request_token != nil {
            UserDefaults.standard.set(request_token, forKey: Token)
        }
        UserDefaults.standard.synchronize()
    }
    
    func setUser(with response: JSON) {
        id = response["id"].intValue
        username = response["username"].stringValue
        
        if id != nil {
            UserDefaults.standard.set(id, forKey: AccountId)
        }
        
        if username != nil {
            UserDefaults.standard.set(username, forKey: UserName)
        }
        UserDefaults.standard.synchronize()
    }
    
    func setSessionId(with response: JSON) {
        sessionId = response["session_id"].stringValue
        
        if sessionId != nil {
            UserDefaults.standard.set(sessionId, forKey: UserSessionId)
        }
        UserDefaults.standard.synchronize()
    }
    
}
