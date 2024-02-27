//
//  AlertViewController.swift
//  2DGame
//
//  Created by Сергей Соловьёв on 14.02.2024.
//

import Foundation
import UIKit

//MARK: - protocols

protocol AlertViewControllerDelegate: AnyObject {
  func didPressRepeatButton()
  func didPressBackButton()
}

final class AlertViewController: UIViewController{
  
  //MARK: - let/var
  
  weak var delegate: AlertViewControllerDelegate?
  let imageManager = ImageManager()
  
  private let scoreLabelAlert = UILabel()
  var scoreCount: Int = 0 {
    didSet {
      scoreLabelAlert.text = "Score: \(scoreCount)"
    }
  }
  
  // MARK: - lifecycle funcs

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  // MARK: - flow funcs

  
  private func configureUI() {
    view.backgroundColor = .systemPink
    navigationItem.hidesBackButton = true
    let backButton = createButton(title: "Back to Menu", yPosition: Constants.screen.height*0.63, action: #selector(backButtonPressed))
    view.addSubview(backButton)
    let repeatButton = createButton(title: "Restart", yPosition: Constants.screen.height*0.76, action: #selector(repeatButtonPressed))
    view.addSubview(repeatButton)
    createScoreLabelAlert()
  }
  
  private func createButton(title :String, yPosition :CGFloat, action :Selector) -> UIButton {
    let button = UIButton(type: .custom)
    button.frame = CGRect(x: Constants.screen.width / 6, y: yPosition, width: Constants.widthButton, height: Constants.heightButton)
    button.setTitle(title, for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont(name: Constants.font, size: Constants.fontSize)
    button.layer.cornerRadius = Constants.cornerRadiusOfButton
    button.backgroundColor = .white
    button.addTarget(self, action: action, for: .touchUpInside)
    
    return button
  }
  
  private func createScoreLabelAlert() {
    scoreLabelAlert.frame = CGRect(x: Constants.screen.width / 3, y: Constants.screen.height / 3, width: Constants.screen.width / 1.5, height: Constants.screen.height / 10)
    scoreLabelAlert.text = "Score: \(scoreCount)"
    scoreLabelAlert.textAlignment = .left
    scoreLabelAlert.adjustsFontSizeToFitWidth = true
    scoreLabelAlert.font = UIFont(name: Constants.font, size: Constants.fontSize)
    view.addSubview(scoreLabelAlert)
  }
  
  @objc func repeatButtonPressed() {
    guard let playerName = UserDefaults.standard.string(forKey: "UserName"),
          let avatarFileName = UserDefaults.standard.string(forKey: "UserAvatarFileName"),
          let avatarData = imageManager.loadImage(from: avatarFileName)?.jpegData(compressionQuality: 1.0) else {
      print("Avatar not found")
      return
    }
    let record = Record(playerName: playerName, date: Date(), score: scoreCount, avatarData: avatarData)
    UserDefaultsManager.shared.saveRecord(record)
    delegate?.didPressRepeatButton()
    navigationController?.popViewController(animated: true)
  }
  
  @objc func backButtonPressed() {
    guard let playerName = UserDefaults.standard.string(forKey: "UserName"),
          let avatarFileName = UserDefaults.standard.string(forKey: "UserAvatarFileName"),
          let avatarData = imageManager.loadImage(from: avatarFileName)?.jpegData(compressionQuality: 1.0) else {
      print("Avatar not found")
      return
    }
    let record = Record(playerName: playerName, date: Date(), score: scoreCount, avatarData: avatarData)
    UserDefaultsManager.shared.saveRecord(record)
    print("backButtonPressed")
    self.delegate?.didPressBackButton()
  }
}

