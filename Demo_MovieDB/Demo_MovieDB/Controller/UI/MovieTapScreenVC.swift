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
    var topRatedMovieArray: Array<Movie> = []
    var nowPlayingMovieArray: Array<Movie> = []
    
    let slideMenu = SlideMenu()
    
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
        showMenuButton()
        getMovieList()
        getTopRatedMovie()
        getNowPlayingMovie()
        tbvMovie.delegate = self
        tbvMovie.dataSource = self
    }
    
    //MARK: - Menu Button
    
    func showMenuButton() {
        let image = UIImage(named: "nav-menu")
        let btnMenu = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(menuButtonPressed(_:)))
        btnMenu.tintColor = UIColor.rpb(red: 0, green: 186, blue: 185)
        navigationItem.leftBarButtonItem = btnMenu
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        slideMenu.showSlideMenu()
    }
    
    //MARK: - Search Button
    
    func btnSearch() {
        let btnSearch = UIBarButtonItem(image: UIImage(named: "ic_search_white"), style: .plain, target: self, action: #selector(btnSearchPressed(_:)))
        btnSearch.tintColor = UIColor.rpb(red: 0, green: 186, blue: 185)
        navigationItem.rightBarButtonItem = btnSearch
    }
        
    @IBAction func btnSearchPressed(_ sender: Any) {
        let vcSearch = storyboard?.instantiateViewController(withIdentifier: "SearchMovieVC") as! SearchMovieVC
        navigationController?.pushViewController(vcSearch, animated: true)
    }
    
    //MARK: -  Segment Action
    
    @IBAction func segmentSwitchChange(_ sender: Any) {
        if self.swicthSegment.selectedSegmentIndex == 0 {
            self.getMovieList()
            self.tbvMovie.reloadData()
        }
        if self.swicthSegment.selectedSegmentIndex == 1 {
            self.getTopRatedMovie()
            self.tbvMovie.reloadData()
        } else {
            self.getNowPlayingMovie()
            self.tbvMovie.reloadData()
        }
    }
    
    //MARK: - Get Movie List
    
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
    
    func getNowPlayingMovie() {
        let params: Parameters = [APIKeyword.apiKey : APIKeyword.api_key]
        self.showHUD(view: self.view)
        APIController.request(manager: .nowPlaying, params: params) { (error, response) in
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
                        self.nowPlayingMovieArray.append(movie)
                    }
                    self.tbvMovie.reloadData()
                }
            }
        }
    }
    
    func getTopRatedMovie() {
        let params: Parameters = [APIKeyword.apiKey : APIKeyword.api_key]
        self.showHUD(view: self.view)
        APIController.request(manager: .topRated, params: params) { (error, response) in
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
                        self.topRatedMovieArray.append(movie)
                    }
                    self.tbvMovie.reloadData()
                }
            }
        }
    }
}

extension MovieTapScreenVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.swicthSegment.selectedSegmentIndex {
        case 0:
            return self.movieArray.count
        case 1:
            return self.nowPlayingMovieArray.count
        case 2:
            return self.topRatedMovieArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTapScreenTBVC", for: indexPath) as! MovieTapScreenTBVC
        if self.movieArray.count > 0 {
            switch self.swicthSegment.selectedSegmentIndex {
            case 0:
                let movie = self.movieArray[indexPath.row]
                cell.imgPoster.sd_setImage(with: URL(string: "\(APIKeyword.imageUrl)\(movie.poster_path!)"), completed: nil)
                cell.lblTitle.text = movie.title
                cell.lblRated.text = String(movie.vote_average)
                cell.lblOverview.text = movie.overview
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            case 1:
                let movie = self.nowPlayingMovieArray[indexPath.row]
                cell.imgPoster.sd_setImage(with: URL(string: "\(APIKeyword.imageUrl)\(movie.poster_path!)"), completed: nil)
                cell.lblTitle.text = movie.title
                cell.lblRated.text = String(movie.vote_average)
                cell.lblOverview.text = movie.overview
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            case 2:
                let movie = self.topRatedMovieArray[indexPath.row]
                cell.imgPoster.sd_setImage(with: URL(string: "\(APIKeyword.imageUrl)\(movie.poster_path!)"), completed: nil)
                cell.lblTitle.text = movie.title
                cell.lblRated.text = String(movie.vote_average)
                cell.lblOverview.text = movie.overview
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            default:
                break
            }
        }
        return cell
    }
    
    func goToDetailScreen(movieArray: Array<Movie>, row: Int) {
        let vcDetailMovie = storyboard?.instantiateViewController(withIdentifier: "DetailMovieVC") as! DetailMovieVC
        vcDetailMovie.movie = movieArray[row]
        navigationController?.pushViewController(vcDetailMovie, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.swicthSegment.selectedSegmentIndex {
        case 0:
            goToDetailScreen(movieArray: self.movieArray, row: indexPath.row)
        case 1:
            goToDetailScreen(movieArray: self.nowPlayingMovieArray, row: indexPath.row)
        case 2:
            goToDetailScreen(movieArray: self.topRatedMovieArray, row: indexPath.row)
        default:
            break
        }
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










