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
        let navc = UINavigationController.init(rootViewController: )
        return true
    }
    
//    func setupLoginViewController() {
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
//        let loginViewController = storyboard.instantiateViewController(withIdentifier: "FirstLoginViewController") as! FirstLoginViewController
//        self.window?.rootViewController = loginViewController
//        self.window?.makeKeyAndVisible()
//    }
    
    func setupHomeViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Movie", bundle: nil)
        let vcMovieTapScreen = storyboard.instantiateViewController(withIdentifier: "MovieTapScreenVC") as! MovieTapScreenVC
        let navc = UINavigationController.init(rootViewController: vcMovieTapScreen)
        navc.navigationBar.barTintColor = .black
        navc.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.rpb(red: 0, green: 186, blue: 185)]
        self.window?.rootViewController = navc
        self.window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

