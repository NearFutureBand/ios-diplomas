import Foundation
import UIKit

@IBDesignable
extension UIView {
  
  @IBInspectable
  public var cornerRadius: CGFloat {
    set (radius) {
      self.layer.cornerRadius = radius
      self.layer.masksToBounds = radius > 0
    }
    
    get {
      return self.layer.cornerRadius
    }
  }
  
  @IBInspectable
  public var borderWidth: CGFloat {
    set (borderWidth) {
      self.layer.borderWidth = borderWidth
    }
    
    get {
      return self.layer.borderWidth
    }
  }
  
  @IBInspectable
  public var borderColor:UIColor? {
    set (color) {
      self.layer.borderColor = color?.cgColor
    }
    
    get {
      if let color = self.layer.borderColor
      {
        return UIColor(cgColor: color)
      } else {
        return nil
      }
    }
  }
  
  func addGradient(colors: [UIColor]) {
    let gradient = CAGradientLayer()
    
    gradient.colors = colors
    gradient.opacity = 0.3
    gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
    gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
    
    gradient.frame = self.bounds
    self.layer.insertSublayer(gradient, at: 0)
  }
  
  func dropShadow() {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.3
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowRadius = 10
    
    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
      layer.shouldRasterize = false
  }
}
