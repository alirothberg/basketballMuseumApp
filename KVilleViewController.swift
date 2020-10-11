//
//  StartViewController.swift
//  Duke Basketball Museum
//
//
//  Copyright © 2019 OIT Duke. All rights reserved.
//

import UIKit

class KVilleViewController: UIViewController {

    var firstRun = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func StartAR(_ sender: UIButton) {
        if(firstRun){
            firstRun = false
            let alert = UIAlertController(title: "Welcome!", message: "Please Point Camera to Designated Images to Start Watching Videos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                self.performSegue(withIdentifier: "startToAR", sender: sender)
            }))
            self.present(alert,animated: true)
            
        }
        else{
            self.performSegue(withIdentifier: "startToAR", sender: sender)

        }

    }
    
}
