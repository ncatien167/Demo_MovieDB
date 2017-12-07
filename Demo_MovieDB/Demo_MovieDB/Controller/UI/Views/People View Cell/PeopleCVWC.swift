//
//  PeopleCVWC.swift
//  Demo_MovieDB
//
//  Created by Apple on 12/1/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit

class PeopleCVWC: UICollectionViewCell {
    
    @IBOutlet weak var imgPeople: UIImageView!
    @IBOutlet weak var lblNamePeople: UILabel!

    func bindData(people: People) {
        lblNamePeople.text = "   \(people.name!)"
        imgPeople.sd_setImage(with: URL(string: "\(APIKeyword.imageUrl)\(people.profile_path!)"), completed: nil)
    }
    
}
