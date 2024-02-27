//
//  RecordsViewController.swift
//  2DGame
//
//  Created by Сергей Соловьёв on 19.02.2024.
//

import Foundation
import UIKit

final class RecordsViewController: UIViewController {
  
  //MARK: - let/var
  
  var tableView: UITableView!
  var records: [Record] = []
  
  // MARK: - lifecycle funcs
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  // MARK: - flow funcs
  
  private func configureUI() {
    navigationItem.hidesBackButton = true
    createBackButton()
    setupRecords()
    createTableView()
  }
  
  private func createBackButton() {
    let backButton = UIBarButtonItem(image: UIImage(systemName: Constants.backButtonSymbol, withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.backButtonSize)), style: .plain, target: self, action: #selector(backButtonPressed))
    backButton.tintColor = .black
    navigationItem.leftBarButtonItem = backButton
  }
  
  private func createTableView() {
    tableView = UITableView(frame: view.bounds, style: .plain)
    tableView.dataSource = self
    view.addSubview(tableView)
    tableView.backgroundColor = .systemPink
  }
  
  @objc func backButtonPressed() {
    navigationController?.popViewController(animated: true)
  }
  
  private func setupRecords() {
    records = UserDefaultsManager.shared.loadRecords().reversed()
  }
}

// MARK: - extensions

extension RecordsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    records.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
    let record = records[indexPath.row]
    cell.textLabel?.text = "Player: \(record.playerName)|Score: \(record.score)"
    cell.detailTextLabel?.text = "Date: \(record.date)"
    if let avatarData = record.avatarData, let avatarImage = UIImage(data: avatarData) {
      cell.imageView?.image = avatarImage
    } else {
      cell.imageView?.image = UIImage(named: "defaultAvatar")
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    "Your Records"
  }
}

