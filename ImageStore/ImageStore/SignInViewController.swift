import UIKit

class SignInViewController: UIViewController {
  
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var greetingLabel: UILabel!
  
  private var password: String? = "123"
  private var isRegister = true {
    didSet {
      greetingLabel.text = isRegister ? "Please, create new password" : "Welcome back!"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    greetingLabel.text = isRegister ? "Please, create new password" : "Welcome back!"
    
    if let savedPassword = UserDefaults.standard.value(forKey: "password") as? String {
      print(savedPassword)
      self.password = savedPassword
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
  
  func goToAddImageScreen () {
    guard let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {
      return
    }
    self.navigationController?.pushViewController(mainViewController, animated: true)
  }
  
  @IBAction func onSignInPress(_ sender: UIButton) {
    self.goToAddImageScreen()
  }
}

extension SignInViewController: UITextFieldDelegate {
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let password = textField.text {
      if password == self.password {
        self.goToGallery()
      }
      UserDefaults.standard.set(password, forKey: "password")
    }
    self.view.endEditing(true)
    return true
  }
}
