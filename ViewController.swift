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

struct ImageFacts { //added
  var descriptionText: String
  var imageName: String
  var labelName: String
}




class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    private var worldConfiguration: ARWorldTrackingConfiguration? //added
    
    var factor = ImageFacts(descriptionText: "", imageName: "" , labelName: "") //added
    
    var lastImageAnchor: ARAnchor!
    var videoNode = SKVideoNode(fileNamed: "wilson.mp4")
    
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
        
    
        worldConfiguration = ARWorldTrackingConfiguration() //added

        guard let referenceObjects = ARReferenceObject.referenceObjects( //sets up object deteciton
          inGroupNamed: "AR Objects", bundle: nil) else {
          fatalError("Missing expected asset catalog resources.")
        }

        worldConfiguration?.detectionObjects = referenceObjects
        
        
        guard let trackedImages = ARReferenceImage.referenceImages( //sets up image detection
          inGroupNamed: "AR Images", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        worldConfiguration?.detectionImages = trackedImages
        
        if let configuration = worldConfiguration {
                 configuration.maximumNumberOfTrackedImages = 1
                 sceneView.session.run(configuration)
               }
        
       
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
           if let imageAnchor = anchor as? ARImageAnchor {
             handleFoundImage(imageAnchor, node)
           } else if let objectAnchor = anchor as? ARObjectAnchor {
             handleFoundObject(objectAnchor, node)
           }
    }
    
    
    private func handleFoundObject(_ objectAnchor: ARObjectAnchor, _ node: SCNNode) { //added
        let name = objectAnchor.referenceObject.name! //
          print(" \(name) was detected")
       
       
          switch name{
          case "Statue_WallaceWade":
            self.factor.descriptionText = "William Wallace Wade (June 15, 1892 – October 7, 1986) was an American football player and coach of football, basketball, and baseball, and college athletics administrator. He served as the head football coach at the University of Alabama from 1923 to 1930 and at Duke University from 1931 to 1941 and again from 1946 to 1950, compiling a career college football record of 171–49–10. His tenure at Duke was interrupted by military service during World War II. Wade's Alabama Crimson Tide football teams of 1925, 1926, and 1930 have been recognized as national champions, while his 1938 Duke team had an unscored upon regular season, giving up its only points in the final minute of the 1939 Rose Bowl."
            self.factor.imageName = "Statue_WallaceWade"
            self.factor.labelName = "Wallace Wade Coach"
           
            DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showInfo", sender: self.factor)
                  }


          default:
            factor.descriptionText = ""
            factor.imageName = ""
            factor.labelName = ""
          }

       
          
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //added
        if segue.identifier == "showInfo" {
      let vc = segue.destination as! ImageInfoVC
      
      vc.finalInfo = self.factor }
    }
    
    
    private func handleFoundImage(_ imageAnchor: ARImageAnchor, _ node: SCNNode) { //when an image weas found
      let name = imageAnchor.referenceImage.name!
      print(" \(name) was detected")
    
      switch name{
      case "TrinityCollege1911":
        self.factor.descriptionText = "Before they were national champions and before they were even known as Duke, the men's basketball team on campus played for Trinity College, which became Duke University in 1924. This photo shows the 1911-12 team, during the seventh year of the basketball program's existence."
        self.factor.imageName = "TrinityCollege1911"
        self.factor.labelName = "Duke's First Basketball Team"

        DispatchQueue.main.async {
          self.performSegue(withIdentifier: "showInfo", sender: self.factor)
        }
            
        //ARVide placement after Image recognition
            
    case "Footprints":
        print("Footprints")
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.8)
                
            let planeNode = SCNNode(geometry: plane)
                planeNode.eulerAngles.x = -.pi / 2
                
                
            let shipScene = SCNScene(named: "art.scnassets/Shoe.scn")!
            let shipNode = shipScene.rootNode.childNodes.first!
                shipNode.position = SCNVector3Zero
                shipNode.position.z = 0.15
                
                planeNode.addChildNode(shipNode)
                
                
                node.addChildNode(planeNode)
            
        case "Footprints2":
        print("Footprints2")
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.8)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            
            
            let shipScene = SCNScene(named: "art.scnassets/Basketballplayer.scn")!
            let shipNode = shipScene.rootNode.childNodes.first!
            shipNode.position = SCNVector3Zero
            shipNode.position.z = 0.15
            
            planeNode.addChildNode(shipNode)
            
            
            node.addChildNode(planeNode)
        
        
        case "CoachKImage":
        print("CoachKImage")
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.9)
                
            let planeNode = SCNNode(geometry: plane)
                planeNode.eulerAngles.x = -.pi / 2
                
                
            let shipScene = SCNScene(named: "art.scnassets/CoachkAnimation/Animated.scn")!
            let shipNode = shipScene.rootNode.childNodes.first!
                shipNode.position = SCNVector3Zero
                shipNode.position.z = 0.15
                shipNode.position.y = -0.12
        
               
          
                planeNode.addChildNode(shipNode)
                
                
                node.addChildNode(planeNode)
            
        //AR video overlay after image detection
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
            
        case "ZionWilliamsonimage":
        print("ZIONNN")
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
            
            
        default:
            factor.descriptionText = ""
            factor.imageName = ""
            factor.labelName = ""
            
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
        }
        if (self.lastImageAnchor != nil && self.lastImageAnchor != imageAnchor) {
            print("video remove")
            self.sceneView.session.remove(anchor: self.lastImageAnchor)
        }
        
        //lastly change the lastImageAnchor to the one what you just detected
        self.lastImageAnchor = imageAnchor
    }
    
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
