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

class SearchMovieVC: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var txfSearchMovie: UITextField!
    @IBOutlet weak var tbvMovie: UITableView!
    var movieArray: [Movie] = []
    var movieFilterArray: [Movie] = []
    var isSearch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUserInterFace() {
        showBackButton()
        searchMovieWith("thor")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var searchText  = textField.text! + string
        
        if string  == "" {
            
        }
        
        if searchText == "" {
            isSearch = false
            tbvMovie.reloadData()
        }
        else{
            getSearchArrayContains(searchText)
        }
        
        return true
    }
    
    // Predicate to filter data
    func getSearchArrayContains(_ text : String) {
        let predicate : NSPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", text)
        movieFilterArray = (movieArray as NSArray).filtered(using: predicate) as! [Movie]
        isSearch = true
        tbvMovie.reloadData()
    }
    
    func searchMovieWith(_ text: String!) {
        let params: Parameters = [APIKeyword.apiKey : "ee8cf966d22254270f6faa1948ecf3fc",
                                  "query" : text]
        APIController.request(manager: .searchMovie, params: params) { (error, response) in
            if error != nil {
                
            } else {
                let results = response!["results"].arrayObject
                for movies in results! {
                    let movie = Movie(with: movies as! [String : Any])
                    self.movieArray.append(movie)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}









