//
//  FirstCell.swift
//  Demo_MovieDB
//
//  Created by Apple on 12/5/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit

class FirstCell: UITableViewCell {

    @IBOutlet weak var imgProfilePath: UIImageView!
    @IBOutlet weak var lblRated: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    
    var detail = DetailMovieVC()
    var movie: Movie!
    var isMarkOfFavorite: Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func removeOutFavorite(movie: Movie, isMarkOfFavorite: Bool) {
        self.movie = movie
        if detail.isMarkOfFavorite == false {
            btnFavorite.setTitle("MASK OF FAVORITE", for: .normal)
        } else {
            btnFavorite.setTitle("REMOVE OUT FAVORITE", for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btnMarkOfFavorite(_ sender: Any) {
        if detail.isMarkOfFavorite == false {
            btnFavorite.setTitle("MASK OF FAVORITE", for: .normal)
            detail.setupbtnMarkOfFavorite(movie: self.movie, isMark: detail.isMarkOfFavorite)
            self.detail.isMarkOfFavorite = true
        } else {
            btnFavorite.setTitle("REMOVE OUT FAVORITE", for: .normal)
            detail.setupbtnMarkOfFavorite(movie: self.movie, isMark: detail.isMarkOfFavorite)
            self.detail.isMarkOfFavorite = false
        }
        
    }
    
}
