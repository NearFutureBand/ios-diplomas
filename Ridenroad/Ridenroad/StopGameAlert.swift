import UIKit

protocol StopGameAlertDelegate: AnyObject {
  func onRestartPress ()
  func onQuitPress ()
}

class StopGameAlert: UIView {
  
  @IBOutlet weak var reasonLabel: UILabel!
  
  weak var delegate: StopGameAlertDelegate?
  
  class func instanceFromNib(reason: String) -> StopGameAlert {
    
    if let stopGameAlert = UINib(nibName: "StopGameAlert", bundle: nil).instantiate(withOwner: nil, options: nil).first as? StopGameAlert {
      
      stopGameAlert.reasonLabel.text = reason
      
      return stopGameAlert
    } else {
      return StopGameAlert()
    }
  }
  
  @IBAction func onRestartPress(_ sender: UIButton) {
    self.delegate?.onRestartPress()
    self.removeFromSuperview()
  }
  
  @IBAction func onQuitPress(_ sender: UIButton) {
    self.delegate?.onQuitPress()
    self.removeFromSuperview()
  }
}
