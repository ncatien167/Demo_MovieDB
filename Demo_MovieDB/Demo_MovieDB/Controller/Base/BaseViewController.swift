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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setupUserInterFace() {
        
    }
    
    func showAlertTitle(_ title: String, _ message: String, _ view: UIViewController) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    
    //MARK: - Back Button
    
    func showBackButton() {
        let image = UIImage(named: "ic_keyboard_arrow_left_white_36pt")
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        backButton.tintColor = UIColor.rpb(red: 0, green: 186, blue: 185)
        backButton.setImage(image, for: .normal)
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
