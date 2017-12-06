//
//  SecondCell.swift
//  Demo_MovieDB
//
//  Created by Apple on 12/5/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit

class SecondCell: UITableViewCell {

    
    @IBOutlet weak var lblOverview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func bindData(movie: Movie) {
        lblOverview.text = movie.overview
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
