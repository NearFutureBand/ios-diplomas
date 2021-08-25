import Foundation

class GameSettings: NSObject, Codable {
  var difficulty: Int
  var carType: String
  
  public static var difficulties = ["1","2","3","4","5"]
  
  init(difficulty: Int, carType: String) {
    self.difficulty = difficulty
    self.carType = carType
  }
  
  public enum CodingKeys: String, CodingKey {
    case difficulty, carType
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(self.difficulty, forKey: .difficulty)
    try container.encode(self.carType, forKey: .carType)
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.difficulty = try container.decode(Int.self, forKey: .difficulty)
    self.carType = try container.decode(String.self, forKey: .carType)
  }
  
}

