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
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieArray = []
        getFavoriteMovie()
    }
    
    override func setupUserInterFace() {
        getAllGenres()
        showMenuButton()
        refreshData()
        tbvMovie.rowHeight = 181
        tbvMovie.estimatedRowHeight = 181
        tbvMovie.delegate = self
        tbvMovie.dataSource = self
        tbvMovie.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
    }
    
    func getFavoriteMovie() {
        let params: Parameters = [APIKeyword.apiKey : APIKeyword.api_key, APIKeyword.Account.sessionId: Parameter.sessionId, "page" : page]
        self.showHUD(view: self.view)
        APIController.request(manager: .getFavoriteMovie, params: params, result: { (error, response) in
            self.hideHUD(view: self.view)
            if error != nil {
                self.showAlertTitle("Error", error!, self, nil)
            } else {
                let results = response!["results"]
                for movies in results {
                    let movie = Movie(with: movies.1)
                    self.movieArray.append(movie)
                }
                self.tbvMovie.reloadData()
            }
        })
    }
    
    //MARK: - Get Genres
    
    func getAllGenres() {
        APIController.request(manager: .getGenres, params: Parameter.paramApiKey) { (error, response) in
            if error != nil {
                self.showAlertTitle("Error", error!, self, nil)
            } else {
                let results = response!["genres"].arrayObject
                for genres in results! {
                    let genre = Movie.Genres(with: genres as! [String : Any])
                    self.genre.updateValue(genre.name, forKey: String(genre.id))
                }
            }
        }
    }
    
    func setupGenre(with genresId: Array<Int>!) -> String {
        var genresString = ""
        var str = ""
        if !self.genre.isEmpty {
            for id in genresId! {
                let idString = String(id)
                str.append("\(self.genre["\(idString)"] as! String), ")
            }
            genresString = String(str.dropLast(2))
        }
        return genresString
    }
    
    //MARK: - Load more and refresh data
    
    func refreshData() {
        self.tbvMovie.es.addPullToRefresh {
            self.page = 1
            self.movieArray = []
            self.getFavoriteMovie()
            self.tbvMovie.es.stopPullToRefresh(ignoreDate: true)
        }
    }
    
    func loadMoreData() {
        self.page += 1
        self.tbvMovie.es.addInfiniteScrolling {
            self.tbvMovie.es.noticeNoMoreData()
        }
    }
    
}

extension FavoriteVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.movieArray.count - 1 {
            loadMoreData()
        }
    }
    
}

