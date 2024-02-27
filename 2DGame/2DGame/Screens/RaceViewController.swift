//
//  RaceViewController.swift
//  2DGame
//
//  Created by Сергей Соловьёв on 08.02.2024.
//

import UIKit

final class RaceViewController: UIViewController {
  
  final class EnemyCarView: UIView {
    var passed: Bool = false
  }
  
  // MARK: - let/var
  
  let scoreLabel = UILabel()
  let myCar = UIView()
  let leftEnemyCar = UIView()
  let enemyCar2 = UIView()
  let leftEdgeOfRoad = UIView()
  let rightEdgeOfRoad = UIView()
  var middleOfRoadStrips: [UIView] = []
  var rightEnemyCars: [UIView] = []
  var leftEnemyCars: [UIView] = []
  var leftTrees: [UIView] = []
  var rightTrees: [UIView] = []
  var carSpeed: TimeInterval = 4
  let treeInterval = 0.2
  var scoreCount = 0
  var stripsTimer: Timer?
  var leftCarTimer: Timer?
  var rightCarTimer: Timer?
  var leftTreeTimer: Timer?
  var rightTreeTimer: Timer?
  var collisionTimer: Timer?
  var isAlertShown = false
  let alertViewController = AlertViewController()
  let imageManager = ImageManager()
  
  
  
  // MARK: - lifecycle funcs
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  // MARK: - flow funcs
  
  private func configureUI(){
    navigationItem.hidesBackButton = true
    view.backgroundColor = .systemGray
    createRoadStrip()
    createScoreLabel()
    startGame()
    createMyCar()
    createMoveButtons()
  }
  
  private func startGame() {
    checkPlayerNameAndAvatar()
    setupDifficulty()
    setupTimers()
    isAlertShown = false
    
  }
  
  private func setupTimers() {
    leftCarTimer = createTimer(timeInterval: 18, action: #selector(moveLeftEnemyCars))
    rightCarTimer = createTimer(timeInterval: 8, action: #selector(moveRightEnemyCars))
    collisionTimer = createTimer(timeInterval: 0.1, action: #selector(checkCollisions))
    leftTreeTimer = createTimer(timeInterval: treeInterval, action: #selector(moveLeftTrees))
    rightTreeTimer = createTimer(timeInterval: treeInterval, action: #selector(moveRightTrees))
    stripsTimer = createTimer(timeInterval: Constants.stripTimerValue, action: #selector(createMiddleOfStrip))
  }
  
  private func createTimer(timeInterval: Double, action: Selector) -> Timer {
    Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: action, userInfo: nil, repeats: true)
  }
  
  private func createMyCar() {
    myCar.frame = CGRect(x: leftEdgeOfRoad.frame.origin.x + (rightEdgeOfRoad.frame.origin.x - leftEdgeOfRoad.frame.origin.x) / 8 + (leftEdgeOfRoad.frame.origin.x * 0.875 + rightEdgeOfRoad.frame.origin.x * 0.125), y: Constants.screen.height / 1.5, width: Constants.widthCar, height: Constants.heightCar)
    if let savedColor = UserDefaultsManager.shared.color(forKey: "SelectedColor") {
      myCar.backgroundColor = savedColor
    } else {
      myCar.backgroundColor = .black
    }
    myCar.layer.zPosition = 1
    view.addSubview(myCar)
  }
  
  private func checkPlayerNameAndAvatar() {
    if UserDefaults.standard.object(forKey: "UserName") == nil {
      UserDefaults.standard.set("Default", forKey: "UserName")
    }
    if UserDefaults.standard.object(forKey: "UserAvatarFileName") == nil {
      print("UserAvatarIsEmpty")
      guard let defaultAvatar = UIImage(named: "defaultAvatar") else { return }
      if let defaultAvatarData = try? imageManager.saveImage(defaultAvatar) {
        UserDefaults.standard.set(defaultAvatarData, forKey: "UserAvatarFileName")
      }
    }
  }
  
  private func createRoadStrip() {
    leftEdgeOfRoad.backgroundColor = .white
    leftEdgeOfRoad.frame = CGRect(x: Constants.screen.width / 5, y: 0, width: Constants.widthStrip, height: Constants.screen.height)
    view.addSubview(leftEdgeOfRoad)
    
    rightEdgeOfRoad.backgroundColor = .white
    rightEdgeOfRoad.frame = CGRect(x: Constants.screen.width * 0.8, y: 0, width: Constants.widthStrip, height: Constants.screen.height)
    view.addSubview(rightEdgeOfRoad)
  }
  
  private func setupDifficulty() {
    let selectedIndex = UserDefaults.standard.integer(forKey: "Difficulty")
    switch selectedIndex {
    case 0:
      carSpeed = 8
    case 1:
      carSpeed = 6
    case 2:
      carSpeed = 1
    default:
      break
    }
  }
  
  private func createMoveButtons() {
    let moveCarLeftButton = createMoveCarButton(xPosition: Constants.screen.width / 10, action: #selector(moveCarLeft), symbolName: "chevron.left.2")
    moveCarLeftButton.layer.zPosition = 1
    view.addSubview(moveCarLeftButton)
    
    let moveCarRightButton = createMoveCarButton(xPosition: (Constants.screen.width * 0.9 - Constants.screen.width / 5), action: #selector(moveCarRight), symbolName: "chevron.right.2")
    moveCarRightButton.layer.zPosition = 1
    view.addSubview(moveCarRightButton)
  }
  
  private func createMoveCarButton(xPosition :CGFloat, action :Selector, symbolName :String) -> UIButton {
    let moveCarbutton = UIButton(type: .system)
    moveCarbutton.frame = .init(x: xPosition, y: Constants.screen.height / 1.2, width: Constants.screen.width / 5, height: Constants.screen.height / 10)
    moveCarbutton.backgroundColor = .lightGray
    moveCarbutton.alpha = 0.8
    moveCarbutton.layer.cornerRadius = Constants.cornerRadiusOfButton
    moveCarbutton.addTarget(self, action: action, for: .touchUpInside)
    moveCarbutton.setImage(UIImage(systemName: symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
    moveCarbutton.tintColor = .black
    
    return moveCarbutton
  }
  
  private func createScoreLabel() {
    scoreLabel.frame = CGRect(x: Constants.screen.width / 10, y: Constants.screen.height * 0.1, width: Constants.screen.width / 2.5, height: Constants.screen.height / 10)
    scoreLabel.backgroundColor = .lightGray
    scoreLabel.alpha = 0.8
    scoreLabel.layer.cornerRadius = Constants.cornerRadiusOfButton
    scoreLabel.layer.masksToBounds = true
    scoreLabel.font = UIFont(name: Constants.font, size: Constants.fontSize)
    scoreLabel.layer.zPosition = 1
    view.addSubview(scoreLabel)
  }
  
  @objc func moveLeftEnemyCars() {
    for leftEnemyCar in leftEnemyCars {
      UIView.animate(withDuration: carSpeed, animations: {
        leftEnemyCar.frame.origin.y = Constants.screen.height
      }) { _ in
        if leftEnemyCar.frame.origin.y >= Constants.screen.height {
          leftEnemyCar.removeFromSuperview()
        }
      }
    }
    leftEnemyCars = leftEnemyCars.filter { $0.frame.origin.y <= self.view.bounds.height }
    let newLeftEnemyCar = EnemyCarView(frame: CGRect(x: (leftEdgeOfRoad.frame.origin.x + (rightEdgeOfRoad.frame.origin.x - leftEdgeOfRoad.frame.origin.x) / 8), y: -Constants.screen.width / 3, width: Constants.widthCar, height: Constants.heightCar))
    newLeftEnemyCar.backgroundColor = .red
    newLeftEnemyCar.passed = false
    view.addSubview(newLeftEnemyCar)
    leftEnemyCars.append(newLeftEnemyCar)
  }
  
  @objc func createMiddleOfStrip() {
    for strip in middleOfRoadStrips {
      UIView.animate(withDuration: Constants.speedOfRoadStrips) {
        strip.frame.origin.y = Constants.screen.height
      }
    }
    middleOfRoadStrips = middleOfRoadStrips.filter { $0.frame.origin.y <= self.view.bounds.height }
    let newStrip = UIView(frame: CGRect(x: Constants.screen.width / 2, y: 0, width: Constants.widthStrip, height: Constants.heightMiddleStrip))
    newStrip.backgroundColor = .white
    view.addSubview(newStrip)
    middleOfRoadStrips.append(newStrip)
  }
  
  @objc func moveRightEnemyCars() {
    
    for rightEnemyCar in rightEnemyCars {
      UIView.animate(withDuration: carSpeed, animations: {
        rightEnemyCar.frame.origin.y = Constants.screen.height
      }) { _ in
        if rightEnemyCar.frame.origin.y >= Constants.screen.height {
          rightEnemyCar.removeFromSuperview()
        }
      }
    }
    rightEnemyCars = rightEnemyCars.filter { $0.frame.origin.y <= self.view.bounds.height }
    let newRightEnemyCar = EnemyCarView(frame: CGRect(x: (leftEdgeOfRoad.frame.origin.x + (rightEdgeOfRoad.frame.origin.x - leftEdgeOfRoad.frame.origin.x) / 8 + (leftEdgeOfRoad.frame.origin.x * 0.875 + rightEdgeOfRoad.frame.origin.x * 0.125)), y: -Constants.screen.width / 3, width: Constants.widthCar, height: Constants.heightCar))
    newRightEnemyCar.backgroundColor = .red
    newRightEnemyCar.passed = false
    view.addSubview(newRightEnemyCar)
    rightEnemyCars.append(newRightEnemyCar)
  }
  
  private func moveTrees(_ trees: inout [UIView], xOffset: CGFloat) {
    for tree in trees {
      UIView.animate(withDuration: Constants.speedOfTrees) {
        tree.frame.origin.y = Constants.screen.height
      }
    }
    
    trees = trees.filter { $0.frame.origin.y <= self.view.bounds.height }
    
    let newTree = UIImageView(image: .tree)
    newTree.frame = CGRect(x: xOffset, y: -Constants.screen.width / 5, width: Constants.screen.width / 5, height: Constants.screen.width / 5)
    view.addSubview(newTree)
    trees.insert(newTree, at: 0)
  }
  
  @objc func moveLeftTrees() {
    moveTrees(&leftTrees, xOffset: 0)
  }
  
  @objc func moveRightTrees() {
    moveTrees(&rightTrees, xOffset: Constants.screen.width * 0.8)
  }
  
  @objc func moveCarLeft() {
    let leftPositionMyCar = myCar.frame.origin.x - (leftEdgeOfRoad.frame.origin.x * 0.875 + rightEdgeOfRoad.frame.origin.x * 0.125)
    if leftPositionMyCar >= leftEdgeOfRoad.frame.origin.x {
      UIView.animate(withDuration: Constants.speedOfMovement) {
        self.myCar.frame.origin.x -= (self.leftEdgeOfRoad.frame.origin.x * 0.875 + self.rightEdgeOfRoad.frame.origin.x * 0.125)
        self.view.layoutIfNeeded()
      }
    } else {
      crash()
    }
  }
  
  @objc func moveCarRight() {
    let rightPositionMyCar = myCar.frame.origin.x + (leftEdgeOfRoad.frame.origin.x * 0.875 + rightEdgeOfRoad.frame.origin.x * 0.125)
    if rightPositionMyCar <= rightEdgeOfRoad.frame.origin.x {
      UIView.animate(withDuration: Constants.speedOfMovement) {
        self.myCar.frame.origin.x += (self.leftEdgeOfRoad.frame.origin.x * 0.875 + self.rightEdgeOfRoad.frame.origin.x * 0.125)
        self.view.layoutIfNeeded()
      }
    } else {
      crash()
    }
  }
  
  @objc func checkCollisions() {
    for enemyCar in rightEnemyCars + leftEnemyCars {
      if let presentationFrame = enemyCar.layer.presentation()?.frame,
         presentationFrame.intersects(myCar.frame) {
        crash()
      }
      if let presentationEnemyFrame = enemyCar.layer.presentation()?.frame,
         let presentationMyCarFrame = myCar.layer.presentation()?.frame,
         presentationEnemyFrame.origin.y > presentationMyCarFrame.origin.y + presentationMyCarFrame.height {
        if let enemyCarView = enemyCar as? EnemyCarView {
          if !enemyCarView.passed {
            scoreCount += 1
            enemyCarView.passed = true
          }
        }
      }
      
    }
    scoreLabel.text = "Score: \(scoreCount) "
    scoreLabel.textAlignment = .left
    scoreLabel.adjustsFontSizeToFitWidth = true
  }
  
  private func crash() {
    stopTimers()
    if !isAlertShown {
      isAlertShown = true
      alertViewController.scoreCount = self.scoreCount
      showAlert(alertViewController)
    }
  }
  
  private func stopTimers () {
    leftCarTimer?.invalidate()
    rightCarTimer?.invalidate()
    leftTreeTimer?.invalidate()
    rightTreeTimer?.invalidate()
    collisionTimer?.invalidate()
  }
  
}

//MARK: - extensions

extension RaceViewController: AlertViewControllerDelegate {
  func didPressRepeatButton() {
    print("didPressRepeatButton RaceViewController")
    scoreCount = 0
    leftEnemyCars.removeAll()
    rightEnemyCars.removeAll()
    leftTrees.removeAll()
    rightTrees.removeAll()
    middleOfRoadStrips.removeAll()
    stopTimers()
    myCar.removeFromSuperview()
    configureUI()
  }
  
  func didPressBackButton() {
    if let navController = navigationController {
      navController.popToRootViewController(animated: true)
    }
  }
  
  func showAlert(_ alertController: AlertViewController) {
    alertController.delegate = self
    if let navController = navigationController {
      navController.pushViewController(alertController, animated: true)
    }
  }
}

