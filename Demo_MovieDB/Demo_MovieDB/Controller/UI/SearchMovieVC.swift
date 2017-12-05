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
    var movieFilterArray: [Movie] = []
    var isSearch: Bool = false
    var genre: Dictionary <String, Any> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUserInterFace() {
        tabBarController?.tabBar.isHidden = false
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
        searchMovieWith(searchText)
        guard !searchText.isEmpty else {
            movieArray = movieFilterArray
            self.tbvMovie.reloadData()
            return
        }
        movieArray = movieFilterArray.filter({ (movie) -> Bool in
            movie.title.lowercased().contains(searchText.lowercased())
        })
        self.tbvMovie.reloadData()
        movieFilterArray = []
    }
    
    func getSearchArrayContains(_ text : String) {
        let predicate : NSPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", text)
        movieFilterArray = (movieArray as NSArray).filtered(using: predicate) as! [Movie]
        isSearch = true
        tbvMovie.reloadData()
    }
    
    
    
    func searchMovieWith(_ text: String) {
        if text.isEmpty {
            return
        } else {
            let params: Parameters = [APIKeyword.apiKey : "ee8cf966d22254270f6faa1948ecf3fc",
                                  "query" : text]
            APIController.request(manager: .searchMovie, params: params) { (error, response) in
                if error != nil {
                    self.showAlertTitle("Error", error!, self)
                } else {
                    let results = response!["results"].arrayObject
                    for movies in results! {
                        let movie = Movie(with: movies as! [String : Any])
                        self.movieFilterArray.append(movie)
                    }
                }
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









