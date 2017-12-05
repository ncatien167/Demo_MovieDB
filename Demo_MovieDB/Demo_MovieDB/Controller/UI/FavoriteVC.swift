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
    var genre: Dictionary <String, Any> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieArray.removeAll()
        getFavoriteMovie()
        self.tbvMovie.reloadData()
        getAllGenres()
    }
    
    override func setupUserInterFace() {
        tbvMovie.rowHeight = 181
        tbvMovie.estimatedRowHeight = 181
        tbvMovie.delegate = self
        tbvMovie.dataSource = self
        tbvMovie.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
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
    
    //MARK: - Get Genres
    
    func getAllGenres() {
        let params: Parameters = [APIKeyword.apiKey : APIKeyword.api_key]
        APIController.request(manager: .getGenres, params: params) { (error, response) in
            if error != nil {
                self.showAlertTitle("Error", error!, self)
            } else {
                let results = response!["genres"].arrayObject
                for genres in results! {
                    let genre = Movie.Genres(with: genres as! [String : Any])
                    self.genre.updateValue(genre.name, forKey: String(genre.id))
                }
                print(self.genre)
            }
        }
    }
    
    func setupGenre(with genresId: Array<Int>!) -> String {
        var genresString = ""
        var str = ""
        for id in genresId! {
            let idString = String(id)
            str.append("\(self.genre["\(idString)"] as! String), ")
        }
        genresString = String(str.dropLast(2))
        return genresString
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
            cell.bindData(movie: movie)
            cell.lblRenges.text = self.setupGenre(with: movie.genre_ids as! Array<Int>)
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

