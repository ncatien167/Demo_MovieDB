//
//  UserManager.swift
//  Demo_MovieDB
//
//  Created by Apple on 12/1/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    var createToken: String!
    var request_token: String!
    var guest_session_id: String!
    var id: Int!
    var username: String!
    var sessionId: String!
    
    static let shared = UserManager()
    private override init(){}
    
    init(with response: [String : Any]) {
        createToken      = response["request_token"] as? String ?? ""
        guest_session_id = response["guest_session_id"] as? String ?? ""
    }
    
    func setToken(with response: [String : Any]) {
        request_token = response["request_token"] as? String ?? ""
        if request_token != nil {
            UserDefaults.standard.set(request_token, forKey: "Token")
        }
        UserDefaults.standard.synchronize()
    }
    
    func setUser(with response: [String : Any]) {
        id = response["id"] as? Int ?? -1
        if id != nil {
            UserDefaults.standard.set(id, forKey: "UserId")
        }
        username = response["username"] as? String ?? ""
        if username != nil {
            UserDefaults.standard.set(username, forKey: "UserName")
        }
        UserDefaults.standard.synchronize()
    }
    
    func setSessionId(with response: [String : Any]) {
        sessionId = response["session_id"] as? String ?? ""
        if sessionId != nil {
            UserDefaults.standard.set(sessionId, forKey: "UserSessionId")
        }
        UserDefaults.standard.synchronize()
    }
    
}
