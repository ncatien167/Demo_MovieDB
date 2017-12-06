//
//  FavoriteTBVC.swift
//  Demo_MovieDB
//
//  Created by Apple on 12/1/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit

class FavoriteTBVC: UITableViewCell {
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRated: UILabel!
    @IBOutlet weak var lblRenges: UILabel!
    @IBOutlet weak var lblOverview: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func bindData(movie: Movie) {
        imgPoster.sd_setImage(with: URL(string: "\(APIKeyword.imageUrl)\(movie.poster_path!)"), completed: nil)
        lblTitle.text = movie.title
        lblRated.text = String(movie.vote_average)
        lblOverview.text = movie.overview
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
