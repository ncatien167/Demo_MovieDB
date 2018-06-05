//
//  LoginVC.swift
//  Demo_MovieDB
//
//  Created by Apple on 12/1/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: BaseViewController {

    @IBOutlet weak var txfUsername: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    
    var user: UserManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupUserInterFace() {
        getToken()
    }
    
    func validateTextField(username: String!, password: String!, completion: (Bool, String) -> ()) {
        if username.isEmpty {
            completion(false, "Please enter user name.")
            return
        }
        if password.isEmpty {
            completion(false, "Please enter password.")
            return
        }
        if password.characters.count <= 6 {
            completion(false, "Minimum passwordlength: 8 characters.")
            return
        }
        completion(true, "")
    }
    
    func goToHomeScreen() {
        let app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        app.setupHomeViewController()
    }
    
    @IBAction func btnLoginPressed(_ sender: Any) {
        getTokenWith(username: txfUsername.text!, password: txfPassword.text!)
    }
    
    @IBAction func btnSignUpWithWebsite(_ sender: Any) {
        if let url = NSURL(string: "https://www.themoviedb.org/login") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}

extension LoginVC {
    
    //MARK: - Get Token
    
    func getToken() {
        APIController.request(manager: .getToken, params: Parameter.paramApiKey) { (error, response) in
            if error != nil {
                self.showAlertTitle("Error", error!, self, nil)
            } else {
                self.user = UserManager(with: response!)
                print(self.user.createToken)
            }
        }
    }
    
    func getTokenWith(username: String!, password: String!) {
        validateTextField(username: username, password: password) { (isValidate, message) in
            if isValidate == false {
                self.showAlertTitle("Error", message, self, nil)
                return
            } else {
                let params: Parameters = [APIKeyword.apiKey : APIKeyword.api_key, APIKeyword.Account.username : username!,
                                          APIKeyword.Account.password : password!, APIKeyword.Account.token : user.createToken!]
                self.showHUD(view: self.view)
                APIController.request(manager: .login, params: params) { (error, response) in
                    if error != nil {
                        self.showAlertTitle("Error", error!, self, nil)
                    } else {
                        UserManager.shared.setToken(with: response!)
                        print(UserManager.shared.request_token!)
                        let token = UserManager.shared.request_token!
                        if token.isEmpty {
                            if let id = response?["status_message"].stringValue
                            {
                                self.showAlertTitle("Error", "Status_message: " + id, self, nil)
                                self.hideHUD(view: self.view)
                            }
                        } else {
                            self.createSessionId()
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Get Sesssion ID
    
    func createSessionId() {
        let params: Parameters = [APIKeyword.apiKey : APIKeyword.api_key, APIKeyword.Account.token : UserManager.shared.request_token]
        APIController.request(manager: .sessionId, params: params) { (error, response) in
            if error != nil {
                self.showAlertTitle("Error", error!, self, nil)
            } else {
                UserManager.shared.setSessionId(with: response!)
                print(UserManager.shared.sessionId)
            }
            self.getAccountDetail()
        }
    }
    
    //MARK: - Get Account User
    
    func getAccountDetail() {
        let params: Parameters = [APIKeyword.apiKey : APIKeyword.api_key, APIKeyword.Account.sessionId : UserManager.shared.sessionId]
        APIController.request(manager: .account, params: params) { (error, response) in
            self.hideHUD(view: self.view)
            if error != nil {
                self.showAlertTitle("Error", error!, self, nil)
            } else {
                UserManager.shared.setUser(with: response!)
                self.goToHomeScreen()
            }
        }
    }
    
}











