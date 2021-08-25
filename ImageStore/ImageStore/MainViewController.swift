import UIKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
  
  var images: [UIImage] = []
  var gallery: [Picture] = []
  let commentHeight: CGFloat = 50
  
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.loadGallery()
  }
  
  func loadGallery () {
    if let galleryItems = UserDefaults.standard.value([Picture].self, forKey: "gallery") {
      
      self.gallery = galleryItems
    }
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
  
  func createGalleryItem (fileName: String) {
    let obj = Picture(name: "Name", about: "About", date: Date(), fileName: fileName)
    
    self.gallery.append(obj)
    
    UserDefaults.standard.set(encodable: self.gallery, forKey: "gallery")
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
  
  @IBAction func onGoBack(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}
