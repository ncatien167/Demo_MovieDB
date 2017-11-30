//
//  MovieTapScreenVC.swift
//  Demo_MovieDB
//
//  Created by Apple on 11/30/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class MovieTapScreenVC: BaseViewController {

    @IBOutlet weak var tbvMovie: UITableView!
    var movieArray: Array<Movie> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "MOVIES"
        UINavigationBar.appearance().backgroundColor = .black
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.rpb(red: 0, green: 186, blue: 185)]
    }
    
    override func setupUserInterFace() {
        tbvMovie.rowHeight = 168
        btnSearch()
        getMovieList()
        
        tbvMovie.delegate = self
        tbvMovie.dataSource = self
    }
    
    func btnSearch() {
        let btnSearch = UIBarButtonItem(image: UIImage(named: "ic_search_white"), style: .plain, target: self, action: #selector(btnSearchPressed(_:)))
        navigationItem.rightBarButtonItem = btnSearch
    }
        
    @IBAction func btnSearchPressed(_ sender: Any) {
        let vcSearch = storyboard?.instantiateViewController(withIdentifier: "SearchMovieVC") as! SearchMovieVC
        let navc = UINavigationController.init(rootViewController: vcSearch)
        tabBarController?.present(navc, animated: true, completion: nil)
    }
    
    func getMovieList() {
        let params: Parameters = [APIKeyword.apiKey : "ee8cf966d22254270f6faa1948ecf3fc"]
        APIController.request(manager: .movieList, params: params) { (error, response) in
            
            if error != nil {
                
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

extension MovieTapScreenVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTapScreenTBVC", for: indexPath) as! MovieTapScreenTBVC
        if self.movieArray.count > 0 {
            let movie = self.movieArray[indexPath.row]
            cell.imgPoster.sd_setImage(with: URL(string: "\(APIKeyword.imageUrl)\(movie.poster_path!)"), completed: nil)
            cell.lblTitle.text = movie.title
            cell.lblRated.text = String(movie.vote_average)
            cell.txvOverview.text = movie.overview
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










