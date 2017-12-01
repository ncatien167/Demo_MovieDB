//
//  UserManager.swift
//  Demo_MovieDB
//
//  Created by Apple on 12/1/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    
    var request_token: String!
    var guest_session_id: String!
    var id: Int!
    var username: String!
    
    init(with response: [String : Any]) {
        request_token = response["request_token"] as? String ?? ""
        guest_session_id = response["guest_session_id"] as? String ?? ""
    }
    
    init(responseAccount: [String : Any]) {
        id = responseAccount["id"] as? Int ?? -1
        username = responseAccount["username"] as? String ?? ""
    }
    
}
