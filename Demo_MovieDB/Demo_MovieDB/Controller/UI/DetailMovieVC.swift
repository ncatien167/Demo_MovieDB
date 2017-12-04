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
    @IBOutlet weak var btnFavorite: UIButton!
    
    var isMarkOfFavorite: Bool!
    var movieArray: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = movie.title
    }
    
    override func setupUserInterFace() {
        isMarkOfFavorite = true
        showBackButton()
        getFavoriteMovie(idMovie: movie.id)
        getMovieWith(id: movie.id)
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
        if isMarkOfFavorite == false {
            removeFavorite(with: movie.id)
            self.btnFavorite.setTitle("MASK OF FAVORITE", for: .normal)
            isMarkOfFavorite = true
        } else {
            markAsFaviriteMovie(with: movie.id)
            self.btnFavorite.setTitle("REMOVE FAVORITE", for: .normal)
            isMarkOfFavorite = false
        }
    }
}

extension DetailMovieVC {
    
    func getMovieWith(id : Int) {
        let path = "movie/\(id)"
        let params: Parameters = [APIKeyword.apiKey : "ee8cf966d22254270f6faa1948ecf3fc"]
        self.showHUD(view: self.view)
        APIController.request(path: path, params: params, manager: .movieDetail) { (error, response) in
            self.hideHUD(view: self.view)
            if error != nil {
                self.showAlertTitle("Error", error!, self)
            } else {
                let data = response?.dictionaryObject
                let movie = Movie(with: data!)
                self.setupDataDetail(movie: movie)
            }
        }
    }
    
    func markAsFaviriteMovie(with id: Int) {
        let requestBody = ["media_type": "movie",
                           "media_id": movie.id,
                           "favorite": isMarkOfFavorite] as [String : Any]
        let sessionId = UserDefaults.standard.value(forKey: "UserSessionId")!
        let path = "account/7702565/favorite?api_key=\(APIKeyword.api_key)&session_id=\(sessionId)"
        
        APIController.request(path: path, params: requestBody, manager: .addFavoriteMovie) { (error, response) in
            if error != nil {
                self.showAlertTitle("Error", error!, self)
            } else {
                self.showAlertTitle("Confirm", "As movie to favorite is susseccfuly", self)
            }
        }
    }
    
    func getFavoriteMovie(idMovie: Int) {
        let id = UserDefaults.standard.value(forKey: "UserId")!
        let sessionId = UserDefaults.standard.value(forKey: "UserSessionId")!
        let params: Parameters = [APIKeyword.apiKey : APIKeyword.api_key,
                                  APIKeyword.Account.sessionId: sessionId]
        
        let path = "account/\(id)/favorite/movies"
        self.showHUD(view: self.view)
        APIController.request(path: path, params: params, manager: .getFavoriteMovie) { (error, response) in
            self.hideHUD(view: self.view)
            if error != nil {
                self.showAlertTitle("Error", error!, self)
            } else {
                let results = response!["results"].arrayObject
                for data in results! {
                    let movie = Movie(with: data as! [String : Any])
                    if idMovie == movie.id {
                        self.btnFavorite.setTitle("REMOVE FAVORITE", for: .normal)
                        self.isMarkOfFavorite = false
                    }
                }
            }
        }
    }
    
    func removeFavorite(with id: Int) {
        let requestBody = ["media_type": "movie",
                           "media_id": id,
                           "favorite": isMarkOfFavorite] as [String : Any]
        let accountId = UserDefaults.standard.value(forKey: "UserId")!
        //"https://api.themoviedb.org/3/account/7702565/favorite? api_key=ee8cf966d22254270f6faa1948ecf3fc & session_id=6ce04adea96a494fd67d4065c12e912369daa844"
        let sessionId = UserDefaults.standard.value(forKey: "UserSessionId")!
        let path = "account/\(accountId)/favorite?api_key=\(APIKeyword.api_key)&session_id=\(sessionId)"
        
        APIController.request(path: path, params: requestBody, manager: .addFavoriteMovie) { (error, response) in
            if error != nil {
                self.showAlertTitle("Error", error!, self)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}











