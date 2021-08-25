
import UIKit

class GalleryItemCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var galleryImage: UIImageView!
  var picture: Picture?
  var navigateToPictureView: ((_: Picture) -> Void)?;
  static var identifier = "GalleryItemCollectionViewCell"
    
  func configure(with object: Picture, pictureImage: UIImage, navigateToPictureView: @escaping (_: Picture) -> Void) {
    galleryImage.image = pictureImage
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
    galleryImage.addGestureRecognizer(tapRecognizer)
    
    self.picture = object
    self.navigateToPictureView = navigateToPictureView
  }
  
  @IBAction func onTap(_ sender: UITapGestureRecognizer) {
    if let picture = self.picture as Picture?, let navigateToPictureView = self.navigateToPictureView {
      navigateToPictureView(picture)
    }
  }

}
