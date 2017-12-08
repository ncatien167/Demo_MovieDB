//
//  BaseViewController.swift
//  Demo_MovieDB
//
//  Created by Apple on 11/30/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import MBProgressHUD

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterFace()
        setupSlideMenu()
    }
    
    deinit {
        print("[\(type(of: self))] dealloc")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setupUserInterFace() {
        
    }
    
    //MARK: - Tab Slide Menu
    
    lazy var slideMenu: SlideMenu = {
        let mb = SlideMenu()
        mb.baseController = self
        return mb
    }()
    
    func setupSlideMenu() {
        NotificationCenter.default.addObserver(self, selector: #selector(acceptMessageMenu),
                                               name: NSNotification.Name("Go People"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(acceptMessageMenu),
                                               name: NSNotification.Name("Go Favorite"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(acceptMessageMenu),
                                               name: NSNotification.Name("Go Movie"), object: nil)
    }
    
    @objc func acceptMessageMenu(_ notification: Notification) {
        if notification.name.rawValue == "Go Movie" {
            tabBarController?.selectedIndex = 0
        }
        if notification.name.rawValue == "Go People" {
            tabBarController?.selectedIndex = 1
        }
        if notification.name.rawValue == "Go Favorite" {
            tabBarController?.selectedIndex = 2
        }
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        tabBarController?.selectedIndex = menuIndex
    }

    //MARK: - Alert
    
    func showAlertTitle(_ title: String, _ message: String, _ view: UIViewController, _ isMark: Bool?) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: {action in self.popView(isMark: isMark)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func popView(isMark: Bool?) {
        if isMark == false {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Progress HUD
    
    func showHUD(view: UIView) {
        let showHUD = MBProgressHUD.showAdded(to: view, animated: true)
        showHUD.label.text = "Loading"
        showHUD.detailsLabel.text = "Please wait..."
    }
    
    func hideHUD(view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    //MARK: - Menu Button
    
    func showMenuButton() {
        let image = UIImage(named: "nav-menu")
        let btnMenu = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(menuButtonPressed(_:)))
        btnMenu.tintColor = UIColor.rpb(red: 0, green: 186, blue: 185)
        navigationItem.leftBarButtonItem = btnMenu
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        slideMenu.showSlideMenu()
    }
    
    //MARK: - Search Button
    
    func btnSearch() {
        let btnSearch = UIBarButtonItem(image: UIImage(named: "ic_search_white"), style: .plain, target: self, action: #selector(btnSearchPressed(_:)))
        btnSearch.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = btnSearch
    }
    
    @IBAction func btnSearchPressed(_ sender: Any) {
        let vcSearch = storyboard?.instantiateViewController(withIdentifier: "SearchMovieVC") as! SearchMovieVC
        navigationController?.pushViewController(vcSearch, animated: true)
    }
    
    //MARK: - Back Button
    
    func showBackButton() {
        let image = UIImage(named: "ic_keyboard_arrow_left_white_36pt")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        backButton.setImage(image, for: .normal)
        backButton.tintColor = UIColor.rpb(red: 0, green: 186, blue: 185)
        backButton.transform = CGAffineTransform(translationX: -15, y: -2.5)
        backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        let btnView = UIView()
        btnView.addSubview(backButton)
        btnView.frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        let btnCustom = UIBarButtonItem(customView: btnView)
        self.navigationItem.leftBarButtonItem = btnCustom
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
