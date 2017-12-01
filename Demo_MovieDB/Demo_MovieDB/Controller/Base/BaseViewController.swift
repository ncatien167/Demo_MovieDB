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
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonPressed(_:)))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
