//
//  DetailMovieVC.swift
//  Demo_MovieDB
//
//  Created by Apple on 11/30/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class DetailMovieVC: BaseViewController {
    
    @IBOutlet weak var tbvDetail: UITableView!
    
    var movie: Movie!
    var isMarkOfFavorite: Bool!
    var movieArray: [Movie] = []
    var genresString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "DETAIL"
    }
    
    override func setupUserInterFace() {
        showBackButton()
        self.isMarkOfFavorite = true
        if movie != nil {
            getMovieWith(id: movie.id!)
            getFavoriteMovie(idMovie: movie.id!)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(acceptMessage), name: NSNotification.Name("Remove Out Favorite"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(acceptMessage), name: NSNotification.Name("Mark Of Favorite"), object: nil)
    }
    
    @objc func acceptMessage(_ notification: Notification) {
        if notification.name.rawValue == "Remove Out Favorite" {
            removeFavorite(with: movie.id, isMark: self.isMarkOfFavorite)
            self.isMarkOfFavorite = true
        } else {
            markAsFaviriteMovie(with: movie.id, isMark: self.isMarkOfFavorite)
            self.isMarkOfFavorite = false
        }
        tbvDetail.reloadData()
    }
    
    func setupDetailTableView() {
        tbvDetail.dataSource = self
        tbvDetail.delegate = self
        tbvDetail.separatorStyle = .none
        tbvDetail.register(UINib(nibName: "FirstCell", bundle: nil), forCellReuseIdentifier: "FirstCell")
        tbvDetail.register(UINib(nibName: "SecondCell", bundle: nil), forCellReuseIdentifier: "SecondCell")
        tbvDetail.register(UINib(nibName: "ThirdCell", bundle: nil), forCellReuseIdentifier: "ThirdCell")
    }
    
    func setupDataDetail(movie: Movie) {
        var genre = ""
        for genres in movie.genre_ids {
            let genresMovie = Movie.Genres(with: genres as! [String : Any])
            genre.append("\(genresMovie.name!), ")
        }
        genresString = String(genre.dropLast(2))
    }
}

extension DetailMovieVC {
    
    func getMovieWith(id : Int) {
        let path = "movie/\(id)"
        let params: Parameters = [APIKeyword.apiKey : APIKeyword.api_key]
        self.showHUD(view: self.view)
        APIController.request(path: path, params: params, manager: .movieDetail) { (error, response) in
            self.hideHUD(view: self.view)
            if error != nil {
                self.showAlertTitle("Error", error!, self)
            } else {
                let data = response?.dictionaryObject
                let movie = Movie(responseId: data!)
                self.movieArray.append(movie)
                self.setupDataDetail(movie: movie)
            }
            self.tbvDetail.reloadData()
            self.setupDetailTableView()
        }
    }
    
    func markAsFaviriteMovie(with id: Int?, isMark: Bool) {
        let requestBody = ["media_type": "movie", "media_id": id!, "favorite": isMark] as [String : Any]
        let accountId = UserDefaults.standard.value(forKey: "UserId")!
        let sessionId = UserDefaults.standard.value(forKey: "UserSessionId")!
        let path = "account/\(accountId)/favorite?api_key=\(APIKeyword.api_key)&session_id=\(sessionId)"
        self.showHUD(view: self.view)
        APIController.request(path: path, params: requestBody, manager: .addFavoriteMovie) { (error, response) in
            self.hideHUD(view: self.view)
            if error != nil {
                self.showAlertTitle("Error", error!, self)
            } else {
                self.showAlertTitle("Confirm", "As movie to favorite is susseccfuly", self)
            }
        }
    }
    
    func getFavoriteMovie(idMovie: Int) {
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
                for data in results! {
                    let movie = Movie(with: data as! [String : Any])
                    if idMovie == movie.id {
                        self.isMarkOfFavorite = false
                    }
                }
                if self.isMarkOfFavorite == false {
                    NotificationCenter.default.post(name: NSNotification.Name("isMark"), object: nil)
                }
                self.tbvDetail.reloadData()
            }
        }
    }
    
    func removeFavorite(with id: Int, isMark: Bool) {
        let requestBody = ["media_type": "movie", "media_id": id, "favorite": isMark] as [String : Any]
        let accountId = UserDefaults.standard.value(forKey: "UserId")!
        let sessionId = UserDefaults.standard.value(forKey: "UserSessionId")!
        let path = "account/\(accountId)/favorite?api_key=\(APIKeyword.api_key)&session_id=\(sessionId)"
        self.showHUD(view: self.view)
        APIController.request(path: path, params: requestBody, manager: .addFavoriteMovie) { (error, response) in
            self.hideHUD(view: self.view)
            if error != nil {
                self.showAlertTitle("Error", error!, self)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func formatter(money: Double) -> String{
        let number = NSDecimalNumber(decimal: Decimal(money))
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        let result = numberFormatter.string(from: number)
        return result!
    }
    
}

extension DetailMovieVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.movieArray.count > 0 {
            let movie = self.movieArray[indexPath.row]
            if indexPath.row == 0 && indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath) as! FirstCell
                cell.lblGenres.text = genresString
                cell.bindData(movie: movie)
                return cell
            }
            if indexPath.row == 0 && indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SecondCell", for: indexPath) as! SecondCell
                cell.bindData(movie: movie)
                return cell
            }
            if indexPath.row == 0 && indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdCell", for: indexPath) as! ThirdCell
                cell.lblTitleCell.text = "RUNTIME"
                cell.lblInfoCell.text = "\(String(movie.runtime))m"
                return cell
            }
            if indexPath.row == 0 && indexPath.section == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdCell", for: indexPath) as! ThirdCell
                cell.lblTitleCell.text = "REVENUE"
                cell.lblInfoCell.text = self.formatter(money: movie.revenue)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdCell", for: indexPath) as! ThirdCell
                cell.lblTitleCell.text = "BUDGET"
                cell.lblInfoCell.text = self.formatter(money: movie.budget)
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
            return cell
        }
    }
    
}











