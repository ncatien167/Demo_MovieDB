//
//  FavoriteVC.swift
//  Demo_MovieDB
//
//  Created by Apple on 12/1/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FavoriteVC: BaseViewController {

    @IBOutlet weak var tbvMovie: UITableView!
    var movieArray: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieArray.removeAll()
        getFavoriteMovie()
        self.tbvMovie.reloadData()
    }
    
    override func setupUserInterFace() {
        tbvMovie.rowHeight = 181
        tbvMovie.estimatedRowHeight = 181
        tbvMovie.delegate = self
        tbvMovie.dataSource = self
    }
    
    func getFavoriteMovie() {
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
                for movies in results! {
                    let movie = Movie(with: movies as! [String : Any])
                    self.movieArray.append(movie)
                }
                self.tbvMovie.reloadData()
            }
        }
    }
}

extension FavoriteVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.movieArray.count)
        return self.movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTBVC", for: indexPath) as! FavoriteTBVC
        if self.movieArray.count > 0 {
            let movie = self.movieArray[indexPath.row]
            cell.imgPoster.sd_setImage(with: URL(string: "\(APIKeyword.imageUrl)\(movie.poster_path!)"), completed: nil)
            cell.lblTitle.text = movie.title
            cell.lblRated.text = String(movie.vote_average)
            cell.lblOverview.text = movie.overview
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcDetailMovie = storyboard?.instantiateViewController(withIdentifier: "DetailMovieVC") as! DetailMovieVC
        vcDetailMovie.movie = self.movieArray[indexPath.row]
        navigationController?.pushViewController(vcDetailMovie, animated: true)
    }
    
}

