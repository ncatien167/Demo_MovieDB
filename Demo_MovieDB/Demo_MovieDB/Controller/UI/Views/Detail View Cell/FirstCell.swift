//
//  FirstCell.swift
//  Demo_MovieDB
//
//  Created by Apple on 12/5/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit
import Alamofire

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
        self.isMarkOfFavorite = true
        btnFavorite.setTitle("MASK OF FAVORITE", for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(acceptMessage), name: NSNotification.Name("isMark"), object: nil)
    }
    
    @objc func acceptMessage(_ notification: Notification) {
        self.isMarkOfFavorite = false
        btnFavorite.setTitle("REMOVE FROM FAVORITE", for: .normal)
        btnFavorite.backgroundColor = .gray
    }
    
    func bindData(movie: Movie) {
        imgProfilePath.sd_setImage(with: URL(string: "\(APIKeyword.imageUrl)\(movie.backdrop_path!)"), completed: nil)
        lblRated.text = "\(String(movie.vote_average))/10"
        lblTitle.text = movie.title
    }

    @IBAction func btnMarkOfFavorite(_ sender: Any) {
        if self.isMarkOfFavorite == false {
            btnFavorite.setTitle("MASK OF FAVORITE", for: .normal)
            btnFavorite.backgroundColor = UIColor.rpb(red: 0, green: 186, blue: 185)
            self.isMarkOfFavorite = true
        } else {
            btnFavorite.setTitle("REMOVE OUT FAVORITE", for: .normal)
            btnFavorite.backgroundColor = .gray
            self.isMarkOfFavorite = false
        }
        NotificationCenter.default.post(name: NSNotification.Name("Mark Of Favorite"), object: nil)
    }
    
    @IBAction func playTrailerMovie(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("Play Video"), object: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
