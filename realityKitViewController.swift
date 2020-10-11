//
//  realityKitViewController.swift
//  Duke Basketball Museum
//
//  Created by Ali Rothberg on 7/13/20.
//  Copyright © 2020 OIT Duke. All rights reserved.
//

import UIKit
import RealityKit

class realityKitViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()

        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
    }
}
