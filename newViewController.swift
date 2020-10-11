//
//  newViewController.swift
//  Duke Basketball Museum
//
//  Created by Madelyn Cecchini on 7/22/20.
//  Copyright © 2020 OIT Duke. All rights reserved.
//

import UIKit
import AVFoundation

class newViewController: UIViewController {

    
            override func viewDidLoad() {
                super.viewDidLoad()
            }
    
    @IBAction func EvTimeBtn(_ sender: Any) {
        MusicPlayer.shared.startMusic(musicFile: "EverytimeWeTouch")
        sleep(30)
        MusicPlayer.shared.stopBackgroundMusic()
    }
    
    @IBAction func DontStopBtn(_ sender: Any) {
        MusicPlayer.shared.startMusic(musicFile: "DontStopBel")
        sleep(30)
        MusicPlayer.shared.stopBackgroundMusic()
    }
    
    @IBAction func ShotsBtn(_ sender: Any) {
        MusicPlayer.shared.startMusic(musicFile: "Shots")
        sleep(30)
        MusicPlayer.shared.stopBackgroundMusic()
    }
    
    @IBAction func TurbBtn(_ sender: Any) {
        MusicPlayer.shared.startMusic(musicFile: "Turbulence")
        sleep(30)
        MusicPlayer.shared.stopBackgroundMusic()
    }
    
    @IBAction func SAILBtn(_ sender: Any) {
       MusicPlayer.shared.startMusic(musicFile: "SAIL")
        sleep(30)
        MusicPlayer.shared.stopBackgroundMusic()
    }
    
}
