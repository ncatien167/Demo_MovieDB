//
//  DetailMovieVC.swift
//  Demo_MovieDB
//
//  Created by Apple on 11/30/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class DetailMovieVC: BaseViewController {
    
    var movie: Movie!
    
    @IBOutlet weak var imgBackDrop: UIImageView!
    @IBOutlet weak var lblRated: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var txvOverview: UITextView!
    @IBOutlet weak var lblRunTime: UILabel!
    @IBOutlet weak var lblRevenue: UILabel!
    @IBOutlet weak var lblBudget: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = ""
        tabBarController?.hidesBottomBarWhenPushed = false
    }
    
    override func setupUserInterFace() {

        getMovieWith(id: String(movie.id))
    }
    
    func setupDataDetail(movie: Movie) {
        imgBackDrop.sd_setImage(with: URL(string: "\(APIKeyword.imageUrl)\(movie.backdrop_path!)"), completed: nil)
        lblRated.text = "\(String(movie.vote_average))/10"
        lblTitle.text = movie.title
        lblRunTime.text = String(movie.runtime)
        lblRevenue.text = String(movie.revenue)
        lblBudget.text = String(movie.budget)
        txvOverview.text = movie.overview
    }
    
    @IBAction func btnMarkAsFavorite(_ sender: Any) {
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}

extension DetailMovieVC {
    
    func getMovieWith(id : String) {
        let url = "https://api.themoviedb.org/3/movie/\(id)"
        let params: Parameters = [APIKeyword.apiKey : "ee8cf966d22254270f6faa1948ecf3fc"]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                print(response.result.value!)
                let data = JSON(response.result.value!)
                let movie = Movie(with: data.dictionaryObject!)
                self.setupDataDetail(movie: movie)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}











