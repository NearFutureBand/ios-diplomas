//
//  UIView+Extensions.swift
//  ImageStore
//
//  Created by Павел Беляков on 9/5/21.
//

import Foundation
import UIKit

extension UIView {
  @IBInspectable
  public var borderRadius: CGFloat {
    set (borderRadius) {
      guard borderRadius >= 0.0 else {
        return
      }
      self.layer.cornerRadius = borderRadius
    }
    
    get {
      return self.layer.cornerRadius
    }
  }
  
  @IBInspectable
  public var masksToBounds: Bool {
    set (masksToBounds) {
      self.layer.masksToBounds = masksToBounds
    }
    
    get {
      return self.layer.masksToBounds
    }
  }
  
  public func roundCorners(radius: CGFloat) {
    self.layer.masksToBounds = true
    self.layer.cornerRadius = radius
  }
  
  public func addShadow() {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowRadius = 10
           
    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = false
  }
}
