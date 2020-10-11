//
//  HuntForHighlightsViewController.swift
//  Duke Basketball Museum
//
//  Created by Nicholas Kim on 2020/07/13.
//  Copyright © 2020 OIT Duke. All rights reserved.
//

import UIKit

public var image1Change: Bool = false
public var image2Change: Bool = false
public var image3Change: Bool = false
public var image4Change: Bool = false
public var image5Change: Bool = false
public var image6Change: Bool = false
public var image7Change: Bool = false

class HuntForHighlightsViewController: UIViewController{
    
    @IBOutlet weak var imageChange1: UIImageView?
    @IBOutlet weak var imageChange2: UIImageView!
    @IBOutlet weak var imageChange3: UIImageView!
    @IBOutlet weak var imageChange4: UIImageView!
    @IBOutlet weak var imageChange5: UIImageView!
    @IBOutlet weak var imageChange6: UIImageView!
    @IBOutlet weak var imageChange7: UIImageView!
    var gameTimer: Timer?
    
    let defaults = UserDefaults.standard
    
    struct Keys {
        static let austinRivers = "Austin Rivers"
        static let christianLaettner = "Christian Laettner"
        static let coachK = "Coach K"
        static let jjReddick = "JJ Reddick"
        static let rjBarret = "RJ Barret"
        static let treJones = "Tre Jones"
        static let zionWilliamson = "Zion Williamson"
    }
    @IBAction func reset(_ sender: Any) {
        image1Change = false
        image2Change = false
        image3Change = false
        image4Change = false
        image5Change = false
        image6Change = false
        image7Change = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(checkImage), userInfo: nil, repeats: true)
        checkForChecked1()
        checkForChecked2()
        checkForChecked3()
        checkForChecked4()
        checkForChecked5()
        checkForChecked6()
        checkForChecked7()
        }
    
    @objc func checkImage() {
        if image1Change{
            imageChange1?.image = UIImage(named: "Checked Austin Rivers")

        } else{
            imageChange1?.image = UIImage(named: "AustinRiversImage")
        }
        
        if image2Change{
            imageChange2?.image = UIImage(named: "Checked Christian Lattner")
        } else {
            imageChange2?.image = UIImage(named: "ChristianLaettnerImage")
        }
        
        if image3Change{
            imageChange3?.image = UIImage(named: "Checked CoachK")
        } else {
            imageChange3?.image = UIImage(named: "CoachKImage")
        }
        
        if image4Change{
            imageChange4?.image = UIImage(named: "Checked JJReddick")
        } else {
            imageChange4?.image = UIImage(named: "JJReddickImage")
        }

        if image5Change {
            imageChange5?.image = UIImage(named: "Checked RJ Barret")
        } else {
            imageChange5?.image = UIImage(named: "RJBarretimage")
        }
        
        if image6Change {
            imageChange6.image = UIImage(named: "Checked Tre Jones")
        } else {
            imageChange6?.image = UIImage(named: "TreJonesImage")
        }
        
        if image7Change {
            imageChange7.image = UIImage(named: "Checked Zion Williamson")
        } else {
            imageChange7?.image = UIImage(named: "ZionWilliamsonimage")
        }
        
        saveChecked()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gameTimer?.invalidate()
    }
    
    func saveChecked() {
        defaults.set(image1Change, forKey: Keys.austinRivers)
        defaults.set(image2Change, forKey: Keys.christianLaettner)
        defaults.set(image3Change, forKey: Keys.coachK)
        defaults.set(image4Change, forKey: Keys.jjReddick)
        defaults.set(image5Change, forKey: Keys.rjBarret)
        defaults.set(image6Change, forKey: Keys.treJones)
        defaults.set(image7Change, forKey: Keys.zionWilliamson)
    }
    
    func checkForChecked1() {
        let checkAustin = defaults.bool(forKey: Keys.austinRivers)
        
        if checkAustin{
            image1Change = true
        }
    }
    
    func checkForChecked2(){
        let checkChristian = defaults.bool(forKey: Keys.christianLaettner)
        
        if checkChristian{
            image2Change = true
        }
    }
    
    func checkForChecked3(){
        let checkCoachK = defaults.bool(forKey: Keys.coachK)
        
        if checkCoachK{
            image3Change = true
        }
    }
    
    func checkForChecked4(){
        let checkJJReddick = defaults.bool(forKey: Keys.jjReddick)
        
        if checkJJReddick{
            image4Change = true
        }
    }
    
    func checkForChecked5(){
        let checkRJBarret = defaults.bool(forKey: Keys.rjBarret)
        
        if checkRJBarret{
            image5Change = true
        }
    }
    
    func checkForChecked6(){
        let checkTreJones = defaults.bool(forKey: Keys.treJones)
        
        if checkTreJones{
            image6Change = true
        }
    }
    
    func checkForChecked7(){
        let checkZionWilliamson = defaults.bool(forKey: Keys.zionWilliamson)
        
        if checkZionWilliamson{
            image7Change = true
        }
    }
    
    }
