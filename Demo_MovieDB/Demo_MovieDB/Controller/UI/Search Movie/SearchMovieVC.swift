//
//  SearchMovieVC.swift
//  Demo_MovieDB
//
//  Created by Apple on 11/30/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class SearchMovieVC: BaseViewController, UISearchBarDelegate {

    @IBOutlet weak var sbMovie: UISearchBar!
    @IBOutlet weak var tbvMovie: UITableView!
    
    var movieArray: [Movie] = []
    var isSearch: Bool = false
    var genre: Dictionary <String, Any> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUserInterFace() {
        getAllGenres()
        showBackButton()
        navigationItem.title = "SEARCH"
        tbvMovie.rowHeight = 181
        tbvMovie.estimatedRowHeight = 181
        tbvMovie.delegate = self
        tbvMovie.dataSource = self
        sbMovie.delegate = self
        tbvMovie.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
    }
    
    //MARK: - Search Movie
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            movieArray = []
            self.tbvMovie.reloadData()
            return
        }
        searchMovieWith(searchText)
        self.tbvMovie.reloadData()
        movieArray = []
        genre = [:]
    }
    
    func searchMovieWith(_ text: String) {
        if text.isEmpty {
            movieArray = []
            self.tbvMovie.reloadData()
            return
        } else {
            let params: Parameters = [APIKeyword.apiKey : APIKeyword.api_key, "query" : text]
            APIController.request(manager: .searchMovie, params: params) { (error, response) in
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
    
    //MARK: - Get Genres
    
    func getAllGenres() {
        APIController.request(manager: .getGenres, params: Parameter.paramApiKey) { (error, response) in
            if error != nil {
                self.showAlertTitle("Error", error!, self)
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
}

extension SearchMovieVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMovieTBVC", for: indexPath) as! SearchMovieTBVC
        if self.movieArray.count > 0 {
            let movie = self.movieArray[indexPath.row]
            cell.lblRenges.text = self.setupGenre(with: movie.genre_ids as! Array<Int>)
            cell.bindData(movie: movie)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcDetailMovie = storyboard?.instantiateViewController(withIdentifier: "DetailMovieVC") as! DetailMovieVC
        vcDetailMovie.hidesBottomBarWhenPushed = false
        vcDetailMovie.movie = self.movieArray[indexPath.row]
        navigationController?.pushViewController(vcDetailMovie, animated: true)
    }
    
}









