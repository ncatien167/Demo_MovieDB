//
//  AppDelegate.swift
//  Demo_MovieDB
//
//  Created by Apple on 11/30/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let User: String = UserDefaults.standard.value(forKey: "Token") as? String ?? ""
        if User.isEmpty {
            setupLoginViewController()
        } else {
            setupHomeViewController()
        }
        return true
    }
    
    func setupLoginViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vcLogin = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.window?.rootViewController = vcLogin
        self.window?.makeKeyAndVisible()
    }
    
    func setupHomeViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Movie", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "tabBar")
        self.window?.rootViewController = vc
        let myTabBar = self.window?.rootViewController as! UITabBarController
        myTabBar.selectedIndex = 0
        self.window?.makeKeyAndVisible()
    }

}

