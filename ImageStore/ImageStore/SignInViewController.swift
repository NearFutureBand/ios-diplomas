import UIKit

class SignInViewController: UIViewController {
  
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var greetingLabel: UILabel!
  @IBOutlet weak var mainLabelView: UILabel!
  
  private var savedPassword: String? = "123"
  private var typedPassword: String = ""
  private var isRegister = true {
    didSet {
      greetingLabel.text = isRegister ? "Please, create new password" : "Welcome back!"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    greetingLabel.text = isRegister ? "Please, create new password" : "Welcome back!"
    
    if let savedPassword = UserDefaults.standard.value(forKey: "password") as? String {
      self.savedPassword = savedPassword
      self.isRegister = false
      return
    }
  }

  func goToGallery () {
    guard let galleryViewController = self.storyboard?.instantiateViewController(withIdentifier: "GalleryViewController") as? GalleryViewController else {
      return
    }
    self.navigationController?.pushViewController(galleryViewController, animated: true)
  }
  
  @IBAction func onSignInPress(_ sender: UIButton) {
    validatePassword(passwordToCheck: typedPassword)
  }
  
  func validatePassword(passwordToCheck: String) {
    if !isRegister && passwordToCheck == savedPassword {
      self.goToGallery()
    }
    
    if isRegister {
      UserDefaults.standard.set(passwordToCheck, forKey: "password")
      self.goToGallery()
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
}

extension SignInViewController: UITextFieldDelegate {
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let typedPassword = textField.text {
      validatePassword(passwordToCheck: typedPassword)
    }
    self.view.endEditing(true)
    return true
  }
  
  public func textFieldDidEndEditing(_ textField: UITextField) {
    if let password = textField.text {
      typedPassword = password
    }
  }
}
