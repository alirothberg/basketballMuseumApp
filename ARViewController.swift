//
//  ViewController.swift
//  Duke Museum
//
//  Created by Richard Wong, Nicholas Kim, Ali Rothberg, Maddie Cecchini, Fernanda Corona, Caleb Getahun
//  Copyright © 2020 OIT Duke. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVKit


//firstScreen->menuNode->menuScreen
let scene = SCNScene(named: "art.scnassets/hoop.scn")!
let ball = SCNNode(geometry: SCNSphere(radius: 0.05))
var plane = SCNPlane()
let planeNode = SCNNode()
let enlargeNode = SCNNode ()
let fullNode = SCNNode()
let firstScreen = SCNNode ()
var videoNode = SKVideoNode()
var currVidName = ""
var currVidType = ""
var width = CGFloat();
var height = CGFloat();

let oneNode = SCNNode()
let twoNode = SCNNode()
let threeNode = SCNNode()
let fourNode = SCNNode()
let fiveNode = SCNNode()
let sixNode = SCNNode()
let sevenNode = SCNNode()
let eightNode = SCNNode()


class ARViewController: UIViewController, ARSCNViewDelegate {
    

    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBAction func BackButtonTouched(_ sender: Any) {
        videoNode.pause()
        videoNode.removeFromParent()
        
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToSceneView()
        
        // Set the view's delegate
        sceneView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        
        // first see if there is a folder called "AR Resources" Resource Group in our Assets Folder
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) {
            
            // if there is, set the images to track
            configuration.trackingImages = trackedImages
            // at any point in time, only 1 image will be tracked
            configuration.maximumNumberOfTrackedImages = 1
        }
        
        
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchNode(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    
    @objc func touchNode(withGestureRecognizer gestureRecognizer: UIGestureRecognizer) {
        guard gestureRecognizer.state == .ended else{return}
        let taplocation = gestureRecognizer.location(in: sceneView)
        let hittestreults = sceneView.hitTest(taplocation,options: [:])
        guard let hitTestResult = hittestreults.first else { return }
        if hitTestResult.node == ball{
            let rotateOne = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: 5.0)
            ball.runAction(rotateOne)
        }
        else if (hitTestResult.node == enlargeNode || hitTestResult.node==planeNode || hitTestResult.node == fullNode){
            print("touched enlarge")
            videoNode.pause()
            if let path = Bundle.main.path(forResource: currVidName, ofType: currVidType){
                let video = AVPlayer(url: URL(fileURLWithPath: path))
                let videoPlayer = AVPlayerViewController()
                videoPlayer.player = video
                
                present(videoPlayer, animated: true) {
                    video.play()
                }
            }
            
            
            
        }
            
        }
   
    /*
    func numVideo(fileName: String){
        firstScreen.enumerateChildNodes { (node, stop) in
            //videoNode.pause()
            
            if(videoNode.name=="vid"){
                videoNode.pause()
                node.removeFromParentNode()
                
                firstScreen.addChildNode(oneNode)
                firstScreen.addChildNode(twoNode)
                firstScreen.addChildNode(threeNode)
                firstScreen.addChildNode(fourNode)
                firstScreen.addChildNode(fiveNode)
                firstScreen.addChildNode(sixNode)
                firstScreen.addChildNode(sevenNode)
                firstScreen.addChildNode(eightNode)
            }
            
        }
 
      videoNode = SKVideoNode(fileNamed: fileName)
        videoNode.name = "vid"
        videoNode.play()
        // set the size (just a rough one will do)
        
        
        var videoScene = SKScene(size: CGSize(width: 1280, height: 720))
        if(fileName == "WilsonGymPromo.mp4" ){
            videoScene = SKScene(size: CGSize(width: 3840, height: 2160))
            
        }
 
        // center our video to the size of our video scene
        videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        // invert our video so it does not look upside down
        videoNode.yScale = -1.0
        // add the video to our scene
        videoScene.addChild(videoNode)
        // create a plan fballthat has the same real world height and width as our detected image
        let plane = SCNPlane(width: width, height: height)
        // set the first materials content to be our video scene
        plane.firstMaterial?.diffuse.contents = videoScene
        // create a node out of the plane
        let numVideo = SCNNode(geometry: plane)
        numVideo.position = SCNVector3(firstScreen.position.x, firstScreen.position.y, firstScreen.position.z+0.0015)
        // since the created node will be vertical, rotate it along the x axis to have it be horizontal
        //oneVideo.eulerAngles.x = -Float.pi / 2
        // finally add the plane node (which contains the video node) to the added node
        firstScreen.addChildNode(numVideo)
    }
 */
    
    // MARK: - ARSCNViewDelegate
    func nodeWithFile(path: String) -> SCNNode {
        
        if let scene = SCNScene(named: path) {
            
            let node = scene.rootNode.childNodes[0] as SCNNode
            return node
            
        } else {
            print("Invalid path supplied")
            return SCNNode()
        }
        
    }
    
    var lastImageAnchor: ARAnchor!
    var videoNode = SKVideoNode(fileNamed: "wilson.mp4")
    
    func enlarge(imageAnchor: ARImageAnchor){
        let enlarge = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width/6, height: imageAnchor.referenceImage.physicalSize.height/6)
        enlarge.firstMaterial?.diffuse.contents = UIImage(named: "Enlarge")
        enlargeNode.geometry = enlarge
        //menuNode.eulerAngles.x = -Float.pi / 2
        enlargeNode.position = SCNVector3(Float(CGFloat(planeNode.position.x) + imageAnchor.referenceImage.physicalSize.width/2), Float(CGFloat(planeNode.position.y) - imageAnchor.referenceImage.physicalSize.height/2), planeNode.position.z+0.001)
        
        
        let instr = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        instr.firstMaterial?.diffuse.contents = UIImage(named: "fullscreenletter")
        fullNode.geometry = instr
        fullNode.position = SCNVector3(planeNode.position.x, Float(CGFloat(planeNode.position.y) - imageAnchor.referenceImage.physicalSize.height/2), planeNode.position.z+0.0015)
        
        planeNode.addChildNode(enlargeNode)
        planeNode.addChildNode(fullNode)
    }


    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // if the anchor is not of type ARImageAnchor (which means image is not detected), just return
        guard let imageAnchor = anchor as? ARImageAnchor else {return}
        
        let referencedImageName = imageAnchor.referenceImage.name
        
        switch referencedImageName{
        
        case "tvscreen":
            print("rec tv")
            plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            width = imageAnchor.referenceImage.physicalSize.width;
            height = imageAnchor.referenceImage.physicalSize.height;
            // set the first materials content to be our video scene
            //plane.firstMaterial?.diffuse.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
            plane.firstMaterial?.diffuse.contents = UIImage(named:"welcome2")
            //plane.firstMaterial?.diffuse.contents = UIImage(named: "whatever")
            firstScreen.geometry = plane;
            firstScreen.eulerAngles.x = -Float.pi / 2
            
            node.addChildNode(firstScreen)
            
            //one
            let one = SCNPlane(width: width/6, height:height/6)
            one.firstMaterial?.diffuse.contents = UIImage(named: "one")
            oneNode.name = "one"
            oneNode.geometry = one
            
            oneNode.position = SCNVector3(firstScreen.position.x + Float(plane.width/8*5), firstScreen.position.y + Float(plane.height/8*3), firstScreen.position.z+0.001)
            firstScreen.addChildNode(oneNode)
            print("one")
            
            //two
            let two = SCNPlane(width: width/6, height:height/6)
            two.firstMaterial?.diffuse.contents = UIImage(named: "two")
            twoNode.name = "two"
            twoNode.geometry = two
            
            twoNode.position = SCNVector3(firstScreen.position.x + Float(plane.width/8*6.3), firstScreen.position.y + Float(plane.height/8*3), firstScreen.position.z+0.001)
            firstScreen.addChildNode(twoNode)

            //three
            let three = SCNPlane(width: width/6, height:height/6)
            three.firstMaterial?.diffuse.contents = UIImage(named: "three")
            threeNode.name = "three"
            threeNode.geometry = three
            
            threeNode.position = SCNVector3(firstScreen.position.x + Float(plane.width/8*5), firstScreen.position.y + Float(plane.height/8), firstScreen.position.z+0.001)
            firstScreen.addChildNode(threeNode)
            
            //four
            let four = SCNPlane(width: width/6, height:height/6)
            four.firstMaterial?.diffuse.contents = UIImage(named: "four")
            fourNode.name = "four"
            fourNode.geometry = four
            
            fourNode.position = SCNVector3(firstScreen.position.x + Float(plane.width/8*6.3), firstScreen.position.y + Float(plane.height/8), firstScreen.position.z+0.001)
            firstScreen.addChildNode(fourNode)
            
            //five
            let five = SCNPlane(width: width/6, height:height/6)
            five.firstMaterial?.diffuse.contents = UIImage(named: "five")
            fiveNode.name = "five"
            fiveNode.geometry = five

            fiveNode.position = SCNVector3(firstScreen.position.x + Float(plane.width/8*5), firstScreen.position.y - Float(plane.height/8), firstScreen.position.z+0.001)
            firstScreen.addChildNode(fiveNode)

            //six
            let six = SCNPlane(width: width/6, height:height/6)
            six.firstMaterial?.diffuse.contents = UIImage(named: "six")
            sixNode.name = "six"
            sixNode.geometry = six

            sixNode.position = SCNVector3(firstScreen.position.x + Float(plane.width/8*6.3), firstScreen.position.y - Float(plane.height/8), firstScreen.position.z+0.001)
            firstScreen.addChildNode(sixNode)

            //seven
            let seven = SCNPlane(width: width/6, height:height/6)
            seven.firstMaterial?.diffuse.contents = UIImage(named: "seven")
            sevenNode.name = "seven"
            sevenNode.geometry = seven

            sevenNode.position = SCNVector3(firstScreen.position.x + Float(plane.width/8*5), firstScreen.position.y - Float(plane.height/8*3), firstScreen.position.z+0.001)
            firstScreen.addChildNode(sevenNode)

            //eight
            let eight = SCNPlane(width: width/6, height:height/6)
            eight.firstMaterial?.diffuse.contents = UIImage(named: "eight")
            eightNode.name = "eight"
            eightNode.geometry = eight

            eightNode.position = SCNVector3(firstScreen.position.x + Float(plane.width/8*6.3), firstScreen.position.y - Float(plane.height/8*3), firstScreen.position.z+0.001)
            firstScreen.addChildNode(eightNode)
            
//            let menu = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
//            width = imageAnchor.referenceImage.physicalSize.width;
//            height = imageAnchor.referenceImage.physicalSize.height;
//            // set the first materials content to be our video scene
//            menu.firstMaterial?.diffuse.contents = UIImage(named: "menu")
//            menuNode.geometry = menu;
//            //menuNode.eulerAngles.x = -Float.pi / 2
//            menuNode.position = SCNVector3(firstScreen.position.x, firstScreen.position.y, firstScreen.position.z+0.001)
            //node.addChildNode(firstScreen)
//            firstScreen.addChildNode(menuNode)
            
//            //pause
//            let pause = SCNPlane(width: width/6, height:height/6)
//            pause.firstMaterial?.diffuse.contents = UIImage(named: "pause")
//            pauseNode.geometry = pause
//
//            pauseNode.position = SCNVector3(firstScreen.position.x + Float(plane.width/8*5.5), firstScreen.position.y - Float(plane.height/4), firstScreen.position.z+0.002)
//            firstScreen.addChildNode(pauseNode)
       /*
        case "footsteps":
            print("footsteps")
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.8)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            
            
            let shipScene = SCNScene(named: "art.scnassets/ship.scn")!
            let shipNode = shipScene.rootNode.childNodes.first!
            shipNode.position = SCNVector3Zero
            shipNode.position.z = 0.15
            
            planeNode.addChildNode(shipNode)
            
            
            node.addChildNode(planeNode)
            */
        
        case "Outdoor":
            print("Outdoor")
            videoNode = SKVideoNode(fileNamed: "DukeOutdoorAdventures.m4v")
            currVidName = "DukeOutdoorAdventures"
            currVidType = "m4v"
            videoNode.play()
            // set the size (just a rough one will do)
            let videoScene = SKScene(size: CGSize(width: 1280, height: 720))
            // center our video to the size of our video scene
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            // invert our video so it does not look upside down
            videoNode.yScale = -1.0
            // add the video to our scene
            videoScene.addChild(videoNode)
            // create a plan fballthat has the same real world height and width as our detected image
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            // set the first materials content to be our video scene
            plane.firstMaterial?.diffuse.contents = videoScene
            // create a node out of the plane
            planeNode.geometry = plane
            // since the created node will be vertical, rotate it along the x axis to have it be horizontal or parallel to our detected image
            planeNode.eulerAngles.x = -Float.pi / 2
            // finally add the plane node (which contains the video node) to the added node
            node.addChildNode(planeNode)
            
            enlarge(imageAnchor: imageAnchor)
        case "Fitness":
            print("fitness")
            videoNode = SKVideoNode(fileNamed: "DukeFitness.m4v")
            currVidName = "DukeFitness"
            currVidType = "m4v"
            videoNode.play()
            // set the size (just a rough one will do)
            let videoScene = SKScene(size: CGSize(width: 1280, height: 720))
            // center our video to the size of our video scene
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            // invert our video so it does not look upside down
            videoNode.yScale = -1.0
            // add the video to our scene
            videoScene.addChild(videoNode)
            // create a plan fballthat has the same real world height and width as our detected image
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            // set the first materials content to be our video scene
            plane.firstMaterial?.diffuse.contents = videoScene
            // create a node out of the plane
            planeNode.geometry = plane
            // since the created node will be vertical, rotate it along the x axis to have it be horizontal or parallel to our detected image
            planeNode.eulerAngles.x = -Float.pi / 2
            // finally add the plane node (which contains the video node) to the added node
            node.addChildNode(planeNode)
            
            enlarge(imageAnchor: imageAnchor)
        case "PE":
            print("PE")
            //find our video file
            videoNode = SKVideoNode(fileNamed: "DukeRec.mp4")
            currVidName = "DukeRec"
            currVidType = "mp4"
            videoNode.play()
            // set the size (just a rough one will do)
            let videoScene = SKScene(size: CGSize(width: 1280, height: 720))
            // center our video to the size of our video scene
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            // invert our video so it does not look upside down
            videoNode.yScale = -1.0
            // add the video to our scene
            videoScene.addChild(videoNode)
            // create a plan fballthat has the same real world height and width as our detected image
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            // set the first materials content to be our video scene
            plane.firstMaterial?.diffuse.contents = videoScene
            // create a node out of the plane
            planeNode.geometry = plane
            // since the created node will be vertical, rotate it along the x axis to have it be horizontal or parallel to our detected image
            planeNode.eulerAngles.x = -Float.pi / 2
            // finally add the plane node (which contains the video node) to the added node
            node.addChildNode(planeNode)
            print("video playing")
            
            enlarge(imageAnchor: imageAnchor)
            
        case "Footprints":
            print("Footprints")
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                
                plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.8)
                
                let planeNode = SCNNode(geometry: plane)
                planeNode.eulerAngles.x = -.pi / 2
                
                
                let shipScene = SCNScene(named: "art.scnassets/ship.scn")!
                let shipNode = shipScene.rootNode.childNodes.first!
                shipNode.position = SCNVector3Zero
                shipNode.position.z = 0.15
                
                planeNode.addChildNode(shipNode)
                
                
                node.addChildNode(planeNode)
                
        case "RJimage":
            print("RJ")
            //find our video file
            videoNode = SKVideoNode(fileNamed: "RJ.mp4")
            currVidName = "Panda"
            currVidType = "mp4"
            videoNode.play()
            // set the size (just a rough one will do)
            let videoScene = SKScene(size: CGSize(width: 1280, height: 720))
            // center our video to the size of our video scene
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            // invert our video so it does not look upside down
            videoNode.yScale = -1.0
            // add the video to our scene
            videoScene.addChild(videoNode)
            // create a plan fballthat has the same real world height and width as our detected image
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            // set the first materials content to be our video scene
            plane.firstMaterial?.diffuse.contents = videoScene
            // create a node out of the plane
            planeNode.geometry = plane
            // since the created node will be vertical, rotate it along the x axis to have it be horizontal or parallel to our detected image
            planeNode.eulerAngles.x = -Float.pi / 2
            // finally add the plane node (which contains the video node) to the added node
            node.addChildNode(planeNode)
            print("video playing")
            enlarge(imageAnchor: imageAnchor)
 
        /*
        case "Aquatics":
            
            //find our video file
            videoNode = SKVideoNode(fileNamed: "DukeAquatics.m4v")
            currVidName = "DukeAquatics"
            currVidType = "m4v"
            videoNode.play()
            // set the size (just a rough one will do)
            let videoScene = SKScene(size: CGSize(width: 1280, height: 720))
            // center our video to the size of our video scene
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            // invert our video so it does not look upside down
            videoNode.yScale = -1.0
            // add the video to our scene
            videoScene.addChild(videoNode)
            // create a plan fballthat has the same real world height and width as our detected image
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            // set the first materials content to be our video scene
            plane.firstMaterial?.diffuse.contents = videoScene
            // create a node out of the plane
            planeNode.geometry = plane
            // since the created node will be vertical, rotate it along the x axis to have it be horizontal or parallel to our detected image
            planeNode.eulerAngles.x = -Float.pi / 2
            // finally add the plane node (which contains the video node) to the added node
            node.addChildNode(planeNode)
            print("video playing")
            enlarge(imageAnchor: imageAnchor)
          */
        case "SportClubs":
            print("sportCLubs")
            //find our video file
            videoNode = SKVideoNode(fileNamed: "DukeSportClubs.m4v")
            currVidName = "DukeSportClubs"
            currVidType = "m4v"
            videoNode.play()
            // set the size (just a rough one will do)
            let videoScene = SKScene(size: CGSize(width: 1280, height: 720))
            // center our video to the size of our video scene
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            // invert our video so it does not look upside down
            videoNode.yScale = -1.0
            // add the video to our scene
            videoScene.addChild(videoNode)
            // create a plan fballthat has the same real world height and width as our detected image
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            // set the first materials content to be our video scene
            plane.firstMaterial?.diffuse.contents = videoScene
            // create a node out of the plane
            planeNode.geometry = plane
            // since the created node will be vertical, rotate it along the x axis to have it be horizontal or parallel to our detected image
            planeNode.eulerAngles.x = -Float.pi / 2
            // finally add the plane node (which contains the video node) to the added node
            node.addChildNode(planeNode)
            print("video playing")
            enlarge(imageAnchor: imageAnchor)
            
        case "IMSports":
            print("IM Sports")
            //find our video file
            videoNode = SKVideoNode(fileNamed: "DukeIntramurals.m4v")
            currVidName = "DukeIntramurals"
            currVidType = "m4v"
            videoNode.play()
            // set the size (just a rough one will do)
            let videoScene = SKScene(size: CGSize(width: 1280, height: 720))
            // center our video to the size of our video scene
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            // invert our video so it does not look upside down
            videoNode.yScale = -1.0
            // add the video to our scene
            videoScene.addChild(videoNode)
            // create a plan fballthat has the same real world height and width as our detected image
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            // set the first materials content to be our video scene
            plane.firstMaterial?.diffuse.contents = videoScene
            // create a node out of the plane
            planeNode.geometry = plane
            // since the created node will be vertical, rotate it along the x axis to have it be horizontal or parallel to our detected image
            planeNode.eulerAngles.x = -Float.pi / 2
            // finally add the plane node (which contains the video node) to the added node
            node.addChildNode(planeNode)
            print("video playing")
            enlarge(imageAnchor: imageAnchor)
            
            
        default:
            /*if let url = URL(string: "https://www.youtube.com/embed/dfSNlXv-F9w?start=16"){
                UIApplication.shared.open(url)
             }*/
            print("hit default case")
        }
    
        
    }
    
    //at every frame, detect image, compare with the last image stored, and show the node corresponding with the image
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        //if image is hidden, pause
        if node.isHidden{
            self.videoNode.pause()
//            print("hidden")
            //node.removeFromParentNode()
//            if(node.name == "vid"){
//                node.removeFromParentNode()
//            }
        }
        if (self.lastImageAnchor != nil && self.lastImageAnchor != imageAnchor) {
            print("video remove")
            self.sceneView.session.remove(anchor: self.lastImageAnchor)
            //self.videoNode.pause()
        }
        
        //lastly change the lastImageAnchor to the one what you just detected
        self.lastImageAnchor = imageAnchor
    }
    
    //    //Override to create and configure nodes for anchors added to the view's session.
    //    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
    //        let node = SCNNode()
    //
    //        return node
    //    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

extension Int {
    func degreesToRadians() -> CGFloat {
        return CGFloat(self) * CGFloat.pi / 180.0
    }
}
