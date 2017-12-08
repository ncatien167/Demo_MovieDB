//
//  PlayVideoVC.swift
//  Demo_MovieDB
//
//  Created by Apple on 12/7/17.
//  Copyright © 2017 Anh Tien. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class PlayVideoVC: BaseViewController, YTPlayerViewDelegate {
    

    @IBOutlet weak var playerView: YTPlayerView!
    
    var video: Movie.Video!
    var movie: Movie!
    var videoArray: Array<Movie.Video> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        showBackButton()
        
    }
    
    override func setupUserInterFace() {
        showBackButton()
        playerView.delegate = self
        getVideoMovie(with: movie.id)
    }
    
    func loadYoutube(video: Movie.Video) {
        navigationItem.title = video.name!
        playerView.load(withVideoId: video.key!)
        playerView.playVideo()
    }
    
    func getVideoMovie(with id: Int) {
        let path = "movie/\(id)/videos"
        APIController.request(path: path, params: Parameter.paramApiKey, manager: .getVideos) { (error, response) in
            if error != nil {
                self.showAlertTitle("Error", error!, self, nil)
            } else {
                let results = response!["results"].arrayObject
                if (results?.isEmpty)! {
                    self.showAlertTitle("ConFirm", "No video to watch.", self, nil)
                } else {
                    for videos in results! {
                        let video = Movie.Video.init(with: videos as! [String : Any])
                        self.videoArray.append(video)
                    }
                    self.loadYoutube(video: self.videoArray[0])
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
