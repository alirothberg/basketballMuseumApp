//
//  ListenIn (KVille).swift
//  Duke Basketball Museum
//
//  Created by Nicholas Kim on 2020/07/05.
//  Copyright © 2020 OIT Duke. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class ListenIn: UIViewController{
            
    var audioPlayer = AVAudioPlayer()
    
            override func viewDidLoad() {
                super.viewDidLoad()
                
                do{
                    audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath:
                        Bundle.main.path(forResource: "EverytimeWeTouch", ofType: "mp3")!))
                    audioPlayer.prepareToPlay()
                }
                catch{
                    print(error)
                }
            }
    
    
}
