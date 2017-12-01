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

enum segment: Int {
    case Popular = 0
    case Now = 1
    case TopRated = 2
}

class MovieTapScreenVC: BaseViewController {

    @IBOutlet weak var swicthSegment: UISegmentedControl!
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
        vcSearch.tabBarController?.tabBar.isHidden = false
        let navc = UINavigationController.init(rootViewController: vcSearch)
        tabBarController?.present(navc, animated: true, completion: nil)
    }
    
    func getMovieList() {
        let params: Parameters = [APIKeyword.apiKey : APIKeyword.api_key]
        self.showHUD(view: self.view)
        APIController.request(manager: .movieList, params: params) { (error, response) in
            self.hideHUD(view: self.view)
            if error != nil {
                self.showAlertTitle("Error", error!, self)
            } else {
                let results = response!["results"].arrayObject
                if results == nil {
                    if let id = response?["status_message"].stringValue
                    {
                        self.showAlertTitle("Error", "Status_message: " + id, self)
                    }
                    
                } else {
                    for movies in results! {
                        let movie = Movie(with: movies as! [String : Any])
                        self.movieArray.append(movie)
                    }
                    self.tbvMovie.reloadData()
                }
            }
        }
        
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
            switch self.swicthSegment.selectedSegmentIndex {
            case 0:
                cell.imgPoster.sd_setImage(with: URL(string: "\(APIKeyword.imageUrl)\(movie.poster_path!)"), completed: nil)
                cell.lblTitle.text = movie.title
                cell.lblRated.text = String(movie.vote_average)
                cell.lblOverview.text = movie.overview
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            case 1:
                cell.imgPoster.sd_setImage(with: URL(string: "\(APIKeyword.imageUrl)\(movie.poster_path!)"), completed: nil)
                cell.lblTitle.text = movie.title
                cell.lblRated.text = String(movie.vote_average)
                cell.lblOverview.text = movie.overview
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            case 2:
                if movie.vote_average > 7.5 {
                    cell.imgPoster.sd_setImage(with: URL(string: "\(APIKeyword.imageUrl)\(movie.poster_path!)"), completed: nil)
                    cell.lblTitle.text = movie.title
                    cell.lblRated.text = String(movie.vote_average)
                    cell.lblOverview.text = movie.overview
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                }
            default:
                break
            }
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
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTapScreenTBVC", for: indexPath) as! MovieTapScreenTBVC
        setCellColor(UIColor.rpb(red: 200, green: 200, blue: 200), for: cell)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTapScreenTBVC", for: indexPath) as! MovieTapScreenTBVC
        setCellColor(.clear, for: cell)
    }
    
    func setCellColor(_ color: UIColor, for cell: UITableViewCell) {
        cell.contentView.backgroundColor = color
        cell.backgroundColor = color
    }
    
}










