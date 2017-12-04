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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUserInterFace() {
        tabBarController?.tabBar.isHidden = false
        
        showBackButton()
        navigationItem.title = "SEARCH"
        tbvMovie.rowHeight = 181
        tbvMovie.estimatedRowHeight = 181
        tbvMovie.delegate = self
        tbvMovie.dataSource = self
        sbMovie.delegate = self
    }
    
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
}

extension SearchMovieVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.movieArray.count)
        return self.movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMovieTBVC", for: indexPath) as! SearchMovieTBVC
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
        vcDetailMovie.hidesBottomBarWhenPushed = false
        vcDetailMovie.movie = self.movieArray[indexPath.row]
        let navc = UINavigationController.init(rootViewController: vcDetailMovie)
        present(navc, animated: true, completion: nil)
    }
    
}









