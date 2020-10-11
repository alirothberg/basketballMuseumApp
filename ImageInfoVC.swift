

import UIKit
import SceneKit
import ARKit
import CoreMedia

class ImageInfoVC: UIViewController {

 
    @IBOutlet weak var uiLabel: UILabel!
    
    @IBOutlet weak var uiImage: UIImageView!
    
    @IBOutlet weak var uiText: UITextView!
    
  var finalInfo : ImageFacts?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    uiLabel.layer.cornerRadius = 10.0
    uiText.text = finalInfo?.descriptionText
    uiLabel.text = finalInfo?.labelName
    uiImage.image = UIImage(named: finalInfo!.imageName)
    
   
  }

  @IBAction func dismissview(_ sender: Any) { //closes the screen
     self.dismiss(animated: true, completion: nil)
  }
}

