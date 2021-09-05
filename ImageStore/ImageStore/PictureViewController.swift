import UIKit

class PictureViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!

  var savedGallery: [Picture]? = nil
  var savedGalleryImages: [UIImage]?
  var selectedIndex: Int? {
    didSet {
      setImage()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setImage()
    configureGestureRecognizers()
  }
  
  @IBAction func onGoBackPress(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  
  func configureGestureRecognizers() {
    let left = UISwipeGestureRecognizer(target: self, action: #selector(turnNextPicture(_:)))
    left.direction = .left
    imageView.addGestureRecognizer(left)
    
    let right = UISwipeGestureRecognizer(target: self, action: #selector(turnPrevPicture(_:)))
    right.direction = .right
    imageView.addGestureRecognizer(right)
  }
  
  @objc func turnNextPicture(_ sender: UISwipeGestureRecognizer) {
    guard let selectedIndex = self.selectedIndex, let savedGalleryImages = self.savedGalleryImages else {
      return
    }
    guard selectedIndex < savedGalleryImages.count - 1 else {
      self.selectedIndex = 0
      return
    }
    self.selectedIndex = selectedIndex + 1
  }
  
  @objc func turnPrevPicture(_ sender: UISwipeGestureRecognizer) {
    guard let selectedIndex = self.selectedIndex, let savedGalleryImages = self.savedGalleryImages else {
      return
    }
    guard selectedIndex > 0 else {
      self.selectedIndex = savedGalleryImages.count - 1
      return
    }
    self.selectedIndex = selectedIndex - 1
  }
  
  func setImage() {
    if let savedGalleryImages = self.savedGalleryImages, let selectedIndex = self.selectedIndex, let imageView = self.imageView {
      imageView.image = savedGalleryImages[selectedIndex]
    }
  }
  
  
}
