//
//  SlideMenu.swift
//  Demo_MovieDB
//
//  Created by Apple on 12/4/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit

class SettingSlideMenu: NSObject {
    
    let title: String
    let imageName: String
    
    init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }
}

class SlideMenu: NSObject {
    
    let menuView = UIView()
    let contentView = UIView()
    var baseController: BaseViewController?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rpb(red: 0, green: 0, blue: 0)
        return cv
    }()
    
    let cellId = "cellId"
    let labelArray = ["Movie","People","Favorite","Log Out"]
    let imgArray = ["ic_movie_creation_white","ic_person_white","ic_favorite_white","logout-icon"]
    
    func showSlideMenu() {
        if let window = UIApplication.shared.keyWindow {
            menuView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            menuView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(menuView)
            window.addSubview(contentView)
            
            let width = (300/375) * window.frame.size.width
            let x = window.frame.size.width - width
            contentView.frame = CGRect(x: window.frame.width, y: 0, width: width, height: window.frame.size.height)
            
            menuView.frame = window.frame
            menuView.alpha = 0
            
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.menuView.alpha = 1
                self.contentView.frame = CGRect(x: x, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
                
            }, completion: nil)
            
            showCollectionView()
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.menuView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.contentView.frame = CGRect(x: window.frame.width, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
            }
        }
    }
    
    func showCollectionView() {
        contentView.backgroundColor = .black
        contentView.addSubview(collectionView)
        contentView.addContrainsWithFormat("H:|[v0]|", view: collectionView)
        contentView.addContrainsWithFormat("V:|-64-[v0]|", view: collectionView)
    }
    
    func setupLogOut() {
        UserDefaults.standard.removeObject(forKey: "Token")
        UserDefaults.standard.removeObject(forKey: "UserSessionId")
        UserDefaults.standard.removeObject(forKey: "UserId")
        UserDefaults.standard.removeObject(forKey: "UserName")
        let app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        app.setupLoginViewController()
    }
    
    override init() {
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
    }
}

extension SlideMenu: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        let label = labelArray[indexPath.item]
        let img = imgArray[indexPath.item]
        cell.titleLabel.text = label
        cell.imageView.image = UIImage(named: img)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 3 {
            setupLogOut()
        } else {
            baseController?.scrollToMenuIndex(menuIndex: indexPath.item)
            handleDismiss()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
}









