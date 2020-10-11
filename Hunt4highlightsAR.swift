//
//  Hunt4highlightsAR.swift
//  Duke Basketball Museum
//
//  Created by Richard Wong on 17/7/2020.
//  Copyright © 2020 OIT Duke. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVKit


class Hunt4highlightsAR: UIViewController, ARSCNViewDelegate {

    
    
    @IBOutlet weak var sceneView: ARSCNView!
    
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
            if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Images", bundle: Bundle.main) {
                
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
                
            case "ZionWilliamsonimage":
                print("zion")
                //find our video file
                videoNode = SKVideoNode(fileNamed: "ZionWilliamsonVideo.mp4")
                currVidName = "ZionWilliamsonVideo"
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
                image7Change = true
                
            case "RJBarretimage":
            print("RJ")
            //find our video file
            videoNode = SKVideoNode(fileNamed: "RJBarretvideo.mp4")
            currVidName = "RJBarretvideo"
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
            image5Change = true
                
            case "JJReddickImage":
            print("JJ")
            //find our video file
            videoNode = SKVideoNode(fileNamed: "JJReddickVideo.mp4")
            currVidName = "JJReddickVideo"
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
            image4Change = true
                
            case "CoachKImage":
            print("COachk")
            //find our video file
            videoNode = SKVideoNode(fileNamed: "CoachKVideo.mp4")
            currVidName = "CoachKVideo"
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
            image3Change = true
                
            case "ChristianLaettnerImage":
            print("theshot")
            //find our video file
            videoNode = SKVideoNode(fileNamed: "ChristianLaettnerVideo.mp4")
            currVidName = "ChristianLaettnerVideo"
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
            image2Change = true
            
            case "TreJonesImage":
            print("Trejones")
            //find our video file
            videoNode = SKVideoNode(fileNamed: "TreJonesVideo.mp4")
            currVidName = "TreJonesVideo"
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
            image6Change = true
            
            
            case "AustinRiversImage":
            print("zion")
            //find our video file
            videoNode = SKVideoNode(fileNamed: "AustinRiversVideo.mp4")
            currVidName = "AustinRiversVideo"
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
            image1Change = true
            
            
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
