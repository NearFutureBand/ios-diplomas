import UIKit

class TestScrollableViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var images: [UIImage] = []
  var gallery: [Picture] = []
  var oneGalleryItem = Picture()
  let commentHeight: CGFloat = 50
  
  @IBOutlet weak var imageContainer: UIImageView!
  @IBOutlet weak var commentsSection: UIView!
  @IBOutlet weak var textField: UITextField!
  
  @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    loadGallery()
  }
  
  func loadGallery () {
    if let galleryItem = UserDefaults.standard.value(Picture.self, forKey: "galleryItem") {
      oneGalleryItem = galleryItem
      
      let image = loadImage(fileName: oneGalleryItem.fileName)
      imageContainer.image = image
      
      //renderComments(comments: oneGalleryItem.comments)
    }
  }
  
  private func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @IBAction private func keyboardWillShow(_ notification: NSNotification) {
    guard let userInfo = notification.userInfo,
          let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
          let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
    
    if notification.name == UIResponder.keyboardWillHideNotification {
      textFieldBottomConstraint.constant = 0
    } else {
      textFieldBottomConstraint.constant = keyboardScreenEndFrame.height
    }
    
    view.needsUpdateConstraints()
    UIView.animate(withDuration: animationDuration) {
      self.view.layoutIfNeeded()
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }
  
  @IBAction func onAddImagePress(_ sender: Any) {
    showPickerAlert()
  }
  
  func showPickerAlert() {
    let alert = UIAlertController(title: "Choose image source", message: nil, preferredStyle: .actionSheet)
    let libraryAction = UIAlertAction(title: "Photo library", style: .default) { (_) in
      self.showImagePicker(sourceType: .photoLibrary)
    }
    let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
      self.showImagePicker(sourceType: .camera)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alert.addAction(libraryAction)
    alert.addAction(cameraAction)
    alert.addAction(cancelAction)
    self.present(alert, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      guard let fileName = saveImage(image: image) else {
        return
      }
      createGalleryItem(fileName: fileName)
    } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      guard let fileName = saveImage(image: image) else {
        return
      }
      createGalleryItem(fileName: fileName)
      //self.images.append(image)
    }
    
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func showImagePicker(sourceType: UIImagePickerController.SourceType) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    imagePicker.sourceType = sourceType
    imagePicker.modalPresentationStyle = .overCurrentContext
    self.present(imagePicker, animated: true, completion: nil)
  }
  
  func createGalleryItem (fileName: String) {
    let obj = Picture(name: "Name", about: "About", date: Date(), fileName: fileName)
    UserDefaults.standard.set(encodable: obj, forKey: "galleryItem")
    //self.gallery.append(obj)
  }
}
