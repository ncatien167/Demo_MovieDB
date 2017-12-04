//
//  PeopleVC.swift
//  Demo_MovieDB
//
//  Created by Apple on 12/1/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit
import Alamofire

class PeopleVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    func getAllPeople() {
        let params: Parameters = [APIKeyword.apiKey : APIKeyword.api_key]
        
        APIController.request(manager: .getPeople, params: params) { (error, response) in
            if error != nil {
                
            } else {
                let results = response!["results"].arrayObject
                for people in results {
                    
                }
            }
        }
    }

}
