//
//  StartViewController.swift
//  2DGame
//
//  Created by Сергей Соловьёв on 14.02.2024.
//

import Foundation
import UIKit

final class StartViewController: UIViewController {
  
  // MARK: - lifecycle funcs

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  // MARK: - flow funcs

  private func configureUI() {
    view.backgroundColor = .systemPink
    let startButton = createButton(title: "Start", yPosition: Constants.screen.height / 3, action: #selector(startButtonTapped))
    view.addSubview(startButton)
    
    let settingsButton = createButton(title: "Settings", yPosition: Constants.screen.height / 2, action: #selector(settingsButtonTapped))
    view.addSubview(settingsButton)
    
    let recordButton = createButton(title: "Records", yPosition: Constants.screen.height * 2 / 3, action: #selector(recordsButtonTapped))
    view.addSubview(recordButton)
  }
  
  private func createButton(title :String, yPosition :CGFloat, action :Selector) -> UIButton {
    let button = UIButton(type: .custom)
    button.setTitle(title, for: .normal)
    button.frame = CGRect(x: (Constants.screen.width / 2 - (Constants.widthButton) / 2), y: yPosition, width: Constants.widthButton, height: Constants.heightButton)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .black
    button.layer.cornerRadius = Constants.cornerRadiusOfButton
    button.addTarget(self, action: action, for: .touchUpInside)
    return button
  }
  
  @objc func startButtonTapped() {
    let viewController = RaceViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }
  
  @objc func settingsButtonTapped() {
    let settingsViewController = SettingsViewController()
    navigationController?.pushViewController(settingsViewController, animated: true)
  }
  
  @objc func recordsButtonTapped(){
    let recordsViewController = RecordsViewController()
    navigationController?.pushViewController(recordsViewController, animated: true)
  }
}





