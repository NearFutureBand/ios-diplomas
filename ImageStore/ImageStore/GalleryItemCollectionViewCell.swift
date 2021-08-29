
import UIKit

protocol GalleryItemCollectionViewCellDelegate: AnyObject {
  func navigateToPictureViewController (index: Int) -> Void
}

class GalleryItemCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var galleryImage: UIImageView!
  var picture: Picture?
  var pictureImage: UIImage?
  var index: Int?
  weak var delegate: GalleryItemCollectionViewCellDelegate?
  static let identifier =  "GalleryItemCollectionViewCell"

  @IBOutlet weak var buttonViewPicture: UIButton!
  
  func configure(with object: Picture, pictureImage: UIImage, index: Int, delegate: GalleryItemCollectionViewCellDelegate) {
    galleryImage.image = pictureImage
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
    galleryImage.addGestureRecognizer(tapRecognizer)
    
    self.picture = object
    self.delegate = delegate
    self.pictureImage = pictureImage
    self.index = index
  }
  
  @objc func onTap(_ sender: UITapGestureRecognizer) {
    guard let index = self.index else {
      return
    }
    print("navigate \(index)")
    delegate?.navigateToPictureViewController(index: index)
  }
}
