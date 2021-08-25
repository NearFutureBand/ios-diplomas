import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
  
  private let defaultLatitude = 53.928903
  private let defaultLongitude = 27.579533
  private let apiKey = "d3132b98-10ec-4743-8486-a2e3ff6a338c"
  
  private let locationManager = CLLocationManager()
  
  
  
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var windLabel: UILabel!
  @IBOutlet weak var latitudeLabel: UILabel!
  @IBOutlet weak var longitudeLabel: UILabel!
  
  
  private var temperature: Int? {
    didSet {
      self.temperatureLabel.text = temperature != nil ? "\(temperature!)" : "no data"
    }
  }
  private var humidity: Int? {
    didSet {
      self.humidityLabel.text = humidity != nil ? "\(humidity!)" : "no data"
    }
  }
  private var windSpeed: Double? {
    didSet {
      let windSpeedLabelPart = windSpeed != nil ? "\(windSpeed!)" : "--"
      self.windLabel.text = "\(windSpeedLabelPart) \(windDirection ?? "---")"
    }
  }
  private var windDirection: String? {
    didSet {
      let windSpeedLabelPart = windSpeed != nil ? "\(windSpeed!)" : "--"
      self.windLabel.text = "\(windSpeedLabelPart) \(windDirection ?? "---")"
    }
  }
  private var latitude: Double? {
    didSet {
      if let lat = latitude {
        self.latitudeLabel.text = "\(lat)"
      }
    }
  }
  private var longitude: Double? {
    didSet {
      if let lon = longitude {
        self.longitudeLabel.text = "\(lon)"
      }
      
    }
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    sendRequest { (text) in
//      print(text)
//    }
    configureLocationManager()
  }
  
  func getUrl(lat: Double, lon: Double) -> String {
    return "https://api.weather.yandex.ru/v2/informers?lat=\(lat)&lon=\(lon)&lang=ru_RU"
  }
  
  func getWeatherForecast(completion: @escaping ([String: Any]) -> Void) {
    guard let url = URL(string: getUrl(lat: latitude ?? defaultLatitude, lon: longitude ?? defaultLongitude)) else {
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue(apiKey, forHTTPHeaderField: "X-Yandex-API-Key")
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      
      if error == nil, let data = data {
        do {
          if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
            completion(json)
          } else {
            completion([:])
          }
        } catch {
          print(error)
          completion([:])
        }
      }
    }.resume()
  }
  
  private func configureLocationManager() {
    locationManager.requestAlwaysAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    locationManager.delegate = self
    locationManager.startUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocationCoordinate2D = manager.location!.coordinate
    
    print("locations = \(location.latitude) \(location.longitude)")
    locationManager.stopUpdatingLocation()
    latitude = location.latitude
    longitude = location.longitude
    
    getWeatherForecast(completion: { (response) in
      if let generalData = response["fact"] as? [String: Any] {
        DispatchQueue.main.async {
          if let humidity = generalData["humidity"] as? Int {
            self.humidity = humidity
          }
          if let temp = generalData["temp"] as? Int {
            self.temperature = temp
          }
          if let windSpeed = generalData["wind_speed"] as? Double {
            self.windSpeed = windSpeed
          }
          if let windDir = generalData["wind_dir"] as? String {
            self.windDirection = windDir
          }
        }
      }

    })
    
  }
}

