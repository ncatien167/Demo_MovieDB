//
//  SlideMenu.swift
//  Demo_MovieDB
//
//  Created by Apple on 12/4/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit

class SlideMenu: NSObject {
    
    let view: UIView = {
        let view = UIView()
        return view
    }()
    
    let menuView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rpb(red: 0, green: 0, blue: 0)
        return view
    }()
    
    let imgView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "LoginThumb_image")
        img.contentMode = .scaleToFill
        return img
    }()
    
    let logOut: UIButton = {
        let btn = UIButton()
        btn.setTitle("Log Out", for: .normal)
        btn.setImage(UIImage(named: "logout-icon"), for: .normal)
        btn.backgroundColor = UIColor.rpb(red: 0, green: 186, blue: 185)
        return btn
    }()
    
    func showSlideMenu() {
        
        if let window = UIApplication.shared.keyWindow {
            view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            view.frame = window.frame
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(view)
            window.addSubview(menuView)
            
            let width: CGFloat = (300.0/375.0) * window.frame.size.width
            let x = window.frame.width - width
            menuView.frame = CGRect(x: window.frame.width, y: 0, width: width, height: window.frame.height)
            
            view.frame = window.frame
            view.alpha = 0
            
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                
                self.view.alpha = 1
                self.menuView.frame = CGRect(x: x, y: 0, width: self.menuView.frame.width, height: self.menuView.frame.height)
                
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss() {
        
        UIView.animate(withDuration: 1.0) {
            self.view.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.menuView.frame = CGRect(x: window.frame.width, y: 0, width: self.menuView.frame.width, height: self.menuView.frame.height)
            }
        }
    }
    
    func setupLogOut() {
        UserDefaults.standard.removeObject(forKey: "Token")
        UserDefaults.standard.removeObject(forKey: "UserSessionId")
        UserDefaults.standard.removeObject(forKey: "UserId")
        UserDefaults.standard.removeObject(forKey: "UserName")
        let app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        app.setupLoginViewController()
    }
    
    @IBAction func btnLogOutPressed(_ sender: Any) {
        setupLogOut()
    }
    
    func setupDetail() {
        menuView.addSubview(imgView)
        menuView.addSubview(logOut)
        
        menuView.addContrainsWithFormat("H:|[v0]|", view: imgView)
        menuView.addContrainsWithFormat("V:|[v0]|", view: imgView)
        menuView.addContrainsWithFormat("H:|[v0]|", view: logOut)
        menuView.addContrainsWithFormat("V:|-64-[v0(50)]", view: logOut)
        
        
        logOut.addTarget(self, action: #selector(btnLogOutPressed(_:)), for: .touchUpInside)
    }
    
    override init() {
        super.init()
        
        setupDetail()
    }
    
}
