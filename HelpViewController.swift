//
//  HelpViewController.swift
//  Duke Basketball Museum
//
//  Created by codeplus on 07/01/20.
//  Copyright © 2019 OIT Duke. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var HomeButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func homeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)

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
