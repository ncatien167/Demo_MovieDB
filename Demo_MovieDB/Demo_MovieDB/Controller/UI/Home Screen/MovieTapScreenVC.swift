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
import ESPullToRefresh

enum segment: Int {
    case Popular = 0
    case Now = 1
    case TopRated = 2
}

class MovieTapScreenVC: BaseViewController, UITabBarControllerDelegate {

    @IBOutlet weak var swicthSegment: UISegmentedControl!
    @IBOutlet weak var tbvMovie: UITableView!
    
    var popularMovieArray: Array<Movie> = []
    var topRatedMovieArray: Array<Movie> = []
    var nowPlayingMovieArray: Array<Movie> = []
    var genre: Dictionary <String, Any> = [:]
    let pathPopular = "movie/popular"
    let pathNow = "movie/now_playing"
    let pathTopRated = "movie/top_rated"
    var page = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "MOVIES"
        UINavigationBar.appearance().backgroundColor = .black
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.rpb(red: 0, green: 186, blue: 185)]
        swicthSegment.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
    }
    
    override func setupUserInterFace() {
        print(UserDefaults.standard.value(forKey: Token) as? String ?? "")
        print(UserDefaults.standard.value(forKey: AccountId) as? Int ?? -1)
        print(UserDefaults.standard.value(forKey: UserName) as? String ?? "")
        print(UserDefaults.standard.value(forKey: UserSessionId) as? String ?? "")
        tbvMovie.rowHeight = 181
        tbvMovie.estimatedRowHeight = 181
        btnSearch()
        showMenuButton()
        getAllGenres()
        refreshData()
        getMovie(path: pathPopular)
        tbvMovie.delegate = self
        tbvMovie.dataSource = self
        tabBarController?.delegate = self
        tbvMovie.contentInset = UIEdgeInsetsMake(6, 0, 7, 0)
    }
    
    //MARK: -  Segment Action
    
    @IBAction func segmentSwitchChange(_ sender: Any) {
        switch self.swicthSegment.selectedSegmentIndex {
            case 0:
                getMovie(path: pathPopular)
            case 1:
                getMovie(path: pathNow)
            case 2:
                getMovie(path: pathTopRated)
            default:
                break
        }
    }
    
    //MARK: - Get Movie List
    
    func getMovie(path: String) {
        let params: Parameters = [APIKeyword.apiKey : APIKeyword.api_key, "page" : page]
        var array: Array<Movie> = []
        self.showHUD(view: self.view)
        APIController.request(path: path, params: params, manager: .movieList) { (error, response) in
            self.hideHUD(view: self.view)
            if error != nil {
                self.showAlertTitle("Error", error!, self, nil)
            } else {
                let results = response!["results"]
                print(results)
                for movies in results {
                    let movie = Movie(with: movies.1)
                    array.append(movie)
                }
                switch self.swicthSegment.selectedSegmentIndex {
                case 0:
                    self.popularMovieArray = self.popularMovieArray + array
                case 1:
                    self.nowPlayingMovieArray = self.nowPlayingMovieArray + array
                case 2:
                    self.topRatedMovieArray = self.topRatedMovieArray + array
                default:
                    break
                }
                self.tbvMovie.reloadData()
            }
        }
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
            switch self.swicthSegment.selectedSegmentIndex {
            case 0:
                self.popularMovieArray = []
                self.getMovie(path: self.pathPopular)
            case 1:
                self.nowPlayingMovieArray = []
                self.getMovie(path: self.pathNow)
            case 2:
                self.topRatedMovieArray = []
                self.getMovie(path: self.pathTopRated)
            default:
                break
            }
            self.tbvMovie.es.stopPullToRefresh(ignoreDate: true)
        }
    }
    
    func loadMoreData() {
        self.page += 1
        self.tbvMovie.es.addInfiniteScrolling {
            switch self.swicthSegment.selectedSegmentIndex {
            case 0:
                self.getMovie(path: self.pathPopular)
            case 1:
                self.getMovie(path: self.pathNow)
            case 2:
                self.getMovie(path: self.pathTopRated)
            default:
                break
            }
            self.tbvMovie.es.noticeNoMoreData()
        }
    }
    
}

extension MovieTapScreenVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.swicthSegment.selectedSegmentIndex {
        case 0:
            return self.popularMovieArray.count
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
        switch self.swicthSegment.selectedSegmentIndex {
            case 0:
                let movie = self.popularMovieArray[indexPath.row]
                cell.selectionStyle = .default
                cell.lblRenges.text = self.setupGenre(with: movie.genre_ids as! Array<Int>)
                cell.bindData(movie: movie)
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            case 1:
                let movie = self.nowPlayingMovieArray[indexPath.row]
                cell.bindData(movie: movie)
                cell.lblRenges.text = self.setupGenre(with: movie.genre_ids as! Array<Int>)
                cell.bindData(movie: movie)
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            case 2:
                let movie = self.topRatedMovieArray[indexPath.row]
                cell.bindData(movie: movie)
                cell.lblRenges.text = self.setupGenre(with: movie.genre_ids as! Array<Int>)
                cell.bindData(movie: movie)
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            default:
                break
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
                goToDetailScreen(movieArray: self.popularMovieArray, row: indexPath.row)
            case 1:
                goToDetailScreen(movieArray: self.nowPlayingMovieArray, row: indexPath.row)
            case 2:
                goToDetailScreen(movieArray: self.topRatedMovieArray, row: indexPath.row)
            default:
                break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch self.swicthSegment.selectedSegmentIndex {
            case 0:
                if indexPath.row == self.popularMovieArray.count - 1 {
                    loadMoreData()
                }
            case 1:
                if indexPath.row == self.nowPlayingMovieArray.count - 1 {
                    loadMoreData()
                }
            case 2:
                if indexPath.row == self.topRatedMovieArray.count - 1 {
                    loadMoreData()
                }
            default:
                break
        }
    }
    
}










