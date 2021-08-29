import UIKit

class MainViewController: UIViewController {
  var savedGallery: [Picture]? = nil
  let commentHeight: CGFloat = 50
  
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func onGoBack(_ sender: UIButton) {
    goBack()
  }
  
  
  @IBAction func onAddImagePress(_ sender: Any) {
    showPickerAlert()
  }
  
  func showImagePicker(sourceType: UIImagePickerController.SourceType) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    imagePicker.sourceType = sourceType
    imagePicker.modalPresentationStyle = .overCurrentContext
    self.present(imagePicker, animated: true, completion: nil)
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
  
  func createGalleryItem (fileName: String) {
    let newPicture = Picture(name: "Name", about: "About", date: Date(), fileName: fileName)
    if var savedGallery = self.savedGallery {
      savedGallery.append(newPicture)
      UserDefaults.standard.set(encodable: savedGallery, forKey: "gallery")
    }
    self.navigationController?.popViewController(animated: true)
  }
  
  func goBack () {
    self.navigationController?.popViewController(animated: true)
  }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      
      guard let fileName = saveImage(image: image) else {
        return
      }
      self.imageView.image = image
      createGalleryItem(fileName: fileName)
    } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      guard let fileName = saveImage(image: image) else {
        return
      }
      self.imageView.image = image
      createGalleryItem(fileName: fileName)
    }
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}
