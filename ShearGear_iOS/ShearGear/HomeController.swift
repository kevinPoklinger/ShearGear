//
//  HomeController.swift
//  ShearGear
//
//  Created by Kevin on 5/25/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import MediaPlayer

class HomeController: UIViewController {

    @IBOutlet weak var videoView: UIView!
    var moviePlayer: MPMoviePlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo()
    }

    func playVideo() {
        let pathToEx1 = Bundle.main.path(forResource: "pucki33_52217_v2", ofType: "mp4")
        let pathURL = NSURL.fileURL(withPath: pathToEx1!)
        moviePlayer = MPMoviePlayerController(contentURL: pathURL)
        //try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        if let player = moviePlayer {
            player.controlStyle = .embedded
            player.repeatMode = .none
            player.view.frame = videoView.bounds
            player.prepareToPlay()
            player.scalingMode = .aspectFill
            videoView.addSubview(player.view)
        }
        self.view.addSubview(videoView)
    }
    
    @IBAction func onClickContactUs(_ sender: Any) {
        let url = URL(string: "https://www.freebirdshears.com/pages/contact-us")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    
    @IBAction func onClickLogin(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
