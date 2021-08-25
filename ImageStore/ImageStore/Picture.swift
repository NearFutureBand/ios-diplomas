

import Foundation
import UIKit

class Picture: NSObject, Codable {
  
  var name: String
  var about: String?
  var date: Date
  var comments: [String]
  var fileName: String
  var liked: Bool
  
  override init() {
    self.name = ""
    self.about = ""
    self.date = Date()
    self.comments = []
    self.fileName = ""
    self.liked = false
  }
  
  init(name: String, about: String?, date: Date, fileName: String) {
    self.name = name
    self.about = about
    self.date = date
    self.comments = []
    self.fileName = fileName
    self.liked = false
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.name = try container.decode(String.self, forKey: .name)
    self.about = try container.decodeIfPresent(String.self, forKey: .about)
    self.date = try container.decode(Date.self, forKey: .date)
    self.comments = try container.decode([String].self, forKey: .comments)
    self.fileName = try container.decode(String.self, forKey: .fileName)
    self.liked = try container.decode(Bool.self, forKey: .liked)
  }
  
  public enum CodingKeys: String, CodingKey {
    case name, about, date, comments, fileName, liked
  }
  
  
}
