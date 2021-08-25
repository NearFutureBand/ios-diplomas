import UIKit

class AboutViewController: UIViewController {
  
  @IBOutlet weak var disclaimerLabel: UILabel!
  
  @IBOutlet weak var settingVelocityLabel: UILabel!
  @IBOutlet weak var settingCarColorLabel: UILabel!
  @IBOutlet weak var difficultyPicker: UIPickerView!
  @IBOutlet weak var carPicker: UIPickerView!
  
  var settings = GameSettings(difficulty: 1, carType: "car0")
  private let carModels = ["car0", "car1", "car2"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setDisclaimerStyledText()
    self.loadGameSettings()
  }

  func setDisclaimerStyledText () {
    let bold = [
      NSAttributedString.Key.strokeWidth: 3,
    ]
    
    let underlined = [
      NSAttributedString.Key.underlineStyle: 1,
    ]
    
    let textScheme: [[String: Any]] = [
      [
        "text": "This is a ",
        "styles": [:]
      ],
      [
        "text": "mobile ",
        "styles": bold
      ],
      [
        "text": "game. ",
        "styles": [:]
      ],
      [
        "text": "Do not repeat ",
        "styles": underlined
      ],
      [
        "text": "everything happening here in real life! Drive ",
        "styles": [:]
      ],
      [
        "text": "carefully",
        "styles": [NSAttributedString.Key.foregroundColor: UIColor.orange]
      ],
      [
        "text": " and don't forget to use a seatbelt. If you want to race go to a special race track.",
        "styles": [:]
      ]
    ]
    
    let labelText = NSMutableAttributedString()
    
    for text in textScheme {
      if let textString = text["text"] as? String, let textStyle = text["styles"] as? [NSAttributedString.Key: Any] {
        labelText.append(NSAttributedString(string: textString, attributes: textStyle))
      }
    }
    
    self.disclaimerLabel.attributedText = labelText
  }
  
  @IBAction func onSaveSettingsPressed(_ sender: UIButton) {
    UserDefaults.standard.set(encodable: self.settings, forKey: "settings")
  }
  
  @IBAction func onBackPress(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func loadGameSettings () {
    let settings = UserDefaults.standard.value(GameSettings.self, forKey: "settings")
    if let difficulty = settings?.difficulty {
      settingVelocityLabel.text = "\(difficulty)"
     
      let difficultyIndexOptional = GameSettings.difficulties.firstIndex(of: "\(difficulty)")
      if let difficultyIndex = difficultyIndexOptional {
        self.difficultyPicker.selectRow(difficultyIndex, inComponent: 0, animated: false)
      }
      
    }
    if let carType = settings?.carType {
      settingCarColorLabel.text = carType
      let carTypeIndexOptional = self.carModels.firstIndex(of: carType)
      if let carTypeIndex = carTypeIndexOptional {
        self.carPicker.selectRow(carTypeIndex, inComponent: 0, animated: false)
      }
    }
  }
}

extension AboutViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView.tag == 0 {
      return GameSettings.difficulties.count
    }
    if pickerView.tag == 1 {
      return self.carModels.count
    }
    return 0
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView.tag == 0 {
      return GameSettings.difficulties[row]
    }
    if pickerView.tag == 1 {
      return self.carModels[row]
    }
    return ""
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView.tag == 0 {
      self.settings.difficulty = Int(GameSettings.difficulties[row]) ?? 1
    }
    if pickerView.tag == 1 {
      self.settings.carType = self.carModels[row]
    }
  }
}
