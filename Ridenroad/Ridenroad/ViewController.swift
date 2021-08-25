import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var gradientContainer: UIView!
  @IBOutlet weak var buttonAbout: UIButton!
  @IBOutlet weak var buttonStart: UIButton!
  @IBOutlet weak var buttonExit: UIButton!
  var mainButtons: [UIButton] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.mainButtons = [self.buttonAbout, self.buttonStart, self.buttonExit]
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    for button in mainButtons {
      button.dropShadow()
    }
  }
  
  @IBAction func onStartPressed(_ sender: UIButton) {
    guard let roadViewController = self.storyboard?.instantiateViewController(withIdentifier: "RoadViewController") as? RoadViewController else {
      return
    }
    self.navigationController?.pushViewController(roadViewController, animated: true)
  }
  
  @IBAction func onAboutPressed(_ sender: UIButton) {
    guard let aboutViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as? AboutViewController else {
      return
    }
    self.navigationController?.pushViewController(aboutViewController, animated: true)
  }
}

