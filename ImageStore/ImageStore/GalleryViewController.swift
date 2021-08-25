
import UIKit

class GalleryViewController: UIViewController {
  
  @IBOutlet weak var galleryCollectionView: UICollectionView!
  
  private var gallery: [Picture] = []
  private var galleryImages: [UIImage?] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.loadGallery()
  }
  
  func loadGallery () {
    if let savedPictures = UserDefaults.standard.value([Picture].self, forKey: "gallery") {
      gallery = savedPictures
      galleryImages = Array(repeating: nil, count: savedPictures.count)
      print(savedPictures)
      for (i, picture) in gallery.enumerated() {
        print(picture.fileName)
        let image = loadImage(fileName: picture.fileName)
        galleryImages[i] = image
      }
      
      galleryCollectionView.reloadData()
    }
  }
  
  @IBAction func onNavigateToAddImage(_ sender: UIButton) {
    guard let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {
      return
    }
    self.navigationController?.pushViewController(mainViewController, animated: true)
  }
  
  @IBAction func onGoBack(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func navigateToPictureView (picture: Picture) {
    guard let pictureViewController = self.storyboard?.instantiateViewController(withIdentifier: "PictureViewController") as? PictureViewController else {
      return
    }
    pictureViewController.picture = picture
    self.navigationController?.pushViewController(pictureViewController, animated: true)
  }
  
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return galleryImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryItemCollectionViewCell.identifier, for: indexPath) as? GalleryItemCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    if let picture = self.galleryImages[indexPath.row] {
      
      cell.configure(with: self.gallery[indexPath.item], pictureImage: picture, navigateToPictureView: self.navigateToPictureView)
    }

    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let sideSize = (collectionView.frame.size.width - 20)/2
    return CGSize(width: sideSize, height: sideSize)
  }
  
  
}
