//
//  StartViewController.swift
//  Duke Basketball Museum
//
//
//  Copyright © 2019 OIT Duke. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    var firstRun = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func StartButton(_ sender: Any) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
