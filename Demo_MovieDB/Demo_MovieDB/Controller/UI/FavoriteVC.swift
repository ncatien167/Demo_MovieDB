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
    
    override func setupUserInterFace() {
        tbvMovie.rowHeight = 181
        tbvMovie.estimatedRowHeight = 181
        tbvMovie.delegate = self
        tbvMovie.dataSource = self
        getFavoriteMovie()
    }
    
    func getFavoriteMovie() {
        let header = [Header.contentType : Header.Content.application]
        
        let params: Parameters = [APIKeyword.apiKey : "ee8cf966d22254270f6faa1948ecf3fc",
                                  "session_id": "481340b7b3fbf2523e93328ebdeb6548aa5b49dc"]
        let url = "https://api.themoviedb.org/3/account/7702565/favorite/movies"
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case .success:
                let data = JSON(response.result.value!)
                let results = data["results"].arrayObject
                for movies in results! {
                    let movie = Movie(with: movies as! [String : Any])
                    self.movieArray.append(movie)
                }
                self.tbvMovie.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
        vcDetailMovie.hidesBottomBarWhenPushed = false
        vcDetailMovie.movie = self.movieArray[indexPath.row]
        let navc = UINavigationController.init(rootViewController: vcDetailMovie)
        present(navc, animated: true, completion: nil)
    }
    
}

