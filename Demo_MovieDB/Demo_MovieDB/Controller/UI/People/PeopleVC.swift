//
//  PeopleVC.swift
//  Demo_MovieDB
//
//  Created by Apple on 12/1/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class PeopleVC: BaseViewController {

    
    @IBOutlet weak var cvwResultPeple: UICollectionView!
    var peopleArray: Array<People> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupUserInterFace() {
        getAllPeople()
        cvwResultPeple.delegate = self
        cvwResultPeple.dataSource = self
        cvwResultPeple.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
    }
    
    func getAllPeople() {
        let params: Parameters = [APIKeyword.apiKey : APIKeyword.api_key]
        APIController.request(manager: .getPeople, params: params) { (error, response) in
            if error != nil {
                self.showAlertTitle("Error", error!, self)
            } else {
                let results = response!["results"].arrayObject
                for peoples in results! {
                    let people = People(with: peoples as! [String : Any])
                    print(people.name)
                    self.peopleArray.append(people)
                }
                self.cvwResultPeple.reloadData()
            }
        }
    }
}

extension PeopleVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.peopleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleCVWC", for: indexPath) as! PeopleCVWC
        if self.peopleArray.count > 0 {
            let people = self.peopleArray[indexPath.row]
            cell.lblNamePeople.text = "   \(people.name!)"
            cell.imgPeople.sd_setImage(with: URL(string: "\(APIKeyword.imageUrl)\(people.profile_path!)"), completed: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cvwResultPeple.frame.width / 2 - 8, height: 159)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}






