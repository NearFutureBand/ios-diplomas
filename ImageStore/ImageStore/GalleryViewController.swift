
import UIKit

class GalleryViewController: UIViewController {
  
  @IBOutlet weak var galleryCollectionView: UICollectionView!
  
  private var savedGallery: [Picture] = []
  private var savedGalleryImages: [UIImage] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    loadGallery()
  }
  
  @IBAction func onNavigateToAddImage(_ sender: UIButton) {
    guard let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {
      return
    }
    self.navigationController?.pushViewController(mainViewController, animated: true)
    mainViewController.savedGallery = savedGallery
  }
  
  @IBAction func onGoBack(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func loadGallery () {
    if let savedPictures = UserDefaults.standard.value([Picture].self, forKey: "gallery") {
      savedGallery = savedPictures
      savedGalleryImages = Array(repeating: UIImage(), count: savedPictures.count)
      for (i, picture) in savedGallery.enumerated() {
        if let image = loadImage(fileName: picture.fileName) {
          savedGalleryImages[i] = image
        }
      }
      
      
      galleryCollectionView.reloadData()
    }
  }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return savedGalleryImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryItemCollectionViewCell.identifier, for: indexPath) as? GalleryItemCollectionViewCell else {
      return UICollectionViewCell()
    }

    cell.configure(with: savedGallery[indexPath.item], pictureImage: savedGalleryImages[indexPath.row], index: indexPath.item, 
                   delegate: self )

    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let sideSize = (collectionView.frame.size.width - 20)/2
    return CGSize(width: sideSize, height: sideSize)
  }
}

extension GalleryViewController: GalleryItemCollectionViewCellDelegate {
  func navigateToPictureViewController(index: Int) {
    print("navigate from gallery \(index)")
    guard let pictureViewController = self.storyboard?.instantiateViewController(withIdentifier: "PictureViewController") as? PictureViewController else {
      return
    }
    pictureViewController.savedGallery = savedGallery
    pictureViewController.savedGalleryImages = savedGalleryImages
    pictureViewController.selectedIndex = index
    self.navigationController?.pushViewController(pictureViewController, animated: true)
  }
}
