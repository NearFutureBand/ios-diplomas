import UIKit

class CustomTimer {
  
}

class RoadViewController: UIViewController {
  
  var screenWidth: CGFloat = 0
  var screenHeight: CGFloat = 0
  var boundaries: [Double] = []
  var lanesXPositions: [CGFloat] = []
  var roadTimer: Timer? = Timer()
  var npcTimer: Timer? = Timer()
  var collisionTimer: Timer? = Timer()
  
  var player = UIImageView()
  
  var npc: [UIImageView] = []
  var boundaryViews: [UIView] = []
  
  private let carWidth: CGFloat = 34
  private let carHeight: CGFloat = 77
  private let curbRatio: CGFloat = 0.05
  private let distanseBetweenCarsRatio: CGFloat = 0.185
  private let firstLaneXPositionRatio: CGFloat = 0.27
  
  private var difficulty: Int = 1
  // frequency of the road timer
  private var timerTimeInterval: Double = 5
  // speed of the road animation
  private var baseAnimationDuration = 4.98
  private var npcFrequencyTimeInterval: Double = 0.9
  private let collisionTimerTimeInterval = 0.2
  private var playerCarType = "car0"
  
  @IBOutlet weak var road0BottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var road0TopConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.loadGameSettings()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.configureGameParameters()
    //steerRightButton.layer.zPosition = 100
    //steerLeftButton.layer.zPosition = 100
  }
  
  private func configureGameParameters () {
    screenWidth = self.view.frame.width
    screenHeight = self.view.frame.height
    boundaries = [Double(screenWidth * curbRatio), Double(screenWidth * (1 - curbRatio))]
    print("\(screenWidth) \(screenHeight)")
    
    self.timerTimeInterval = self.timerTimeInterval / (Double(self.difficulty) * 0.5 )
    self.baseAnimationDuration = self.timerTimeInterval - 0.02
    self.npcFrequencyTimeInterval = self.npcFrequencyTimeInterval / (Double(self.difficulty) * 0.7)
    print("\(difficulty) \(npcFrequencyTimeInterval)")
    
    self.defineNPCXPositions()
    self.drawBoundaries()
    self.placePlayerCar()
    //self.launchTraffic()
    self.startTimers()
  }
  
  func loadGameSettings () {
    let settings = UserDefaults.standard.value(GameSettings.self, forKey: "settings")
    if let difficulty = settings?.difficulty {
      self.difficulty = difficulty
    }
    if let carType = settings?.carType {
      print(carType)
      self.playerCarType = carType
    }
  }
  
  private func drawBoundaries () {
    for boundary in boundaries {
      let b = UIView(frame: CGRect(x: CGFloat(boundary) - 3, y: 0, width: 6, height: screenHeight
      ))
      view.addSubview(b)
      boundaryViews.append(b)
    }
  }
  
  private func defineNPCXPositions () {
    for i in 0..<4 {
      self.lanesXPositions.append(CGFloat(i) * screenWidth * distanseBetweenCarsRatio - carWidth + screenWidth * firstLaneXPositionRatio)
    }
  }
  
  private func startRoadTimer () {
    guard self.roadTimer == nil else {
      return
    }
    self.roadTimer = Timer.scheduledTimer(withTimeInterval: timerTimeInterval, repeats: true, block: { (timer) in
      self.animateRoad()
    })
    self.roadTimer?.fire()
  }
  private func stopRoadTimer () {
    guard self.roadTimer != nil else { return }
    self.roadTimer?.invalidate()
    self.roadTimer = nil
  }
  private func startNpcTimer () {
    guard self.npcTimer == nil else {
      return
    }
    self.npcTimer = Timer.scheduledTimer(withTimeInterval: npcFrequencyTimeInterval, repeats: true, block: { (timer) in
      self.createNPC()
    })
    self.npcTimer?.fire()
  }
  private func stopNpcTimer () {
    guard self.npcTimer != nil else { return }
    self.npcTimer?.invalidate()
    self.npcTimer = nil
  }
  private func startCollisionTimer () {
    guard self.collisionTimer == nil else {
      return
    }
    self.collisionTimer = Timer.scheduledTimer(withTimeInterval: collisionTimerTimeInterval, repeats: true, block: { (timer) in
      
      // borders
      // TODO можно оптимизировать и проверять координаты машины - не рисовать границы
      if (
        self.boundaryViews[0].frame.intersects(self.player.frame) ||
          self.boundaryViews[1].frame.intersects(self.player.frame)
      ) {
        self.stopGame(reason: "Heeey, be careful with the road's borders!")
      }

      for npcCar in self.npc {
        if let collision = npcCar.layer.presentation()?.frame.intersects(self.player.frame) {
          if collision {
            self.stopGame(reason: "Ooops, good luck in the next run!")
          }
        }
      }
    })
  }
  private func stopCollisionTimer () {
    guard self.collisionTimer != nil else { return }
    self.collisionTimer?.invalidate()
    self.collisionTimer = nil
  }
  
  private func startTimers () {
    startRoadTimer()
    startNpcTimer()
    startCollisionTimer()
  }
  
  private func stopGame (reason: String) {
    self.stopRoadTimer()
    self.stopNpcTimer()
    self.stopCollisionTimer()
    self.showStopGameAlert(reason: reason)
  }
  
  func animateRoad () {
    self.road0BottomConstraint.constant -= self.screenHeight
    self.road0TopConstraint.constant += self.screenHeight
    
    UIView.animate(withDuration: baseAnimationDuration, delay: 0, options: .curveLinear) {
      self.view.layoutIfNeeded()
    } completion: { (_) in
      self.road0BottomConstraint.constant = 0
      self.road0TopConstraint.constant = 0
      self.view.layoutIfNeeded()
    }
  }
  
  func placePlayerCar () {
    player = UIImageView(frame: CGRect(x: screenWidth / 2 - carWidth / 2, y: screenHeight - 100, width: carWidth, height: carHeight))
    player.image = UIImage(named: playerCarType)
    view.addSubview(player)
  }
  
  func createNPC () {
    let xPosition = self.lanesXPositions[Int.random(in: 0..<4)]
    let car = UIImageView(frame: CGRect(x: xPosition, y: -self.carHeight, width: self.carWidth, height: self.carHeight))
    car.image = UIImage(named: "car1")
    view.addSubview(car)
    let thisCarIndex = npc.count
    self.npc.append(car)
    
    UIView.animate(withDuration: Double.random(in: self.baseAnimationDuration * 0.8...self.baseAnimationDuration * 1.2) , delay: 0, options: .curveLinear) {
      car.frame.origin.y += ( self.screenHeight + self.carHeight )
    } completion: { [self] (_) in
      car.removeFromSuperview()
      
      guard thisCarIndex < self.npc.count else {
        return
      }
      
      self.npc.remove(at: thisCarIndex)
    }
  }
  
  func showStopGameAlert (reason: String) {
    let stopGameAlert = StopGameAlert.instanceFromNib(reason: reason)
    stopGameAlert.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
    stopGameAlert.delegate = self
    view.addSubview(stopGameAlert)
  }
  
  @IBAction func onGoBackPress(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func onSteerLeftPress(_ sender: UIButton) {
    UIView.animate(withDuration: 0.2) {
      self.player.frame.origin.x -= 20
    }
  }
  
  @IBAction func onSteerRightPress(_ sender: Any) {
    UIView.animate(withDuration: 0.2) {
      self.player.frame.origin.x += 20
    }
  }
}

extension RoadViewController: StopGameAlertDelegate {
  func onRestartPress() {
    self.startTimers()
  }
  
  func onQuitPress() {
    self.navigationController?.popViewController(animated: true)
  }
  
}
