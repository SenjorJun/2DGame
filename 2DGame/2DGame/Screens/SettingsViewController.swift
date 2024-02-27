//
//  SettingsViewController.swift
//  2DGame
//
//  Created by Сергей Соловьёв on 19.02.2024.
//

import UIKit

//MARK: - protocols

protocol SettingsViewControllerDelegate: AnyObject {
  func didSelectColor(_ color: UIColor)
}

final class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
  //MARK: - let/var
  
  weak var delegate: SettingsViewControllerDelegate?
  let imageManager = ImageManager()
  let colors: [UIColor] = [.black, .yellow, .green, .red, .purple, .blue]
  var pickerView: UIPickerView!
  var colorButton = UIButton()
  let pickAvatarButton = UIButton()
  let chooseColorLabel = UILabel()
  let nameLabel = UILabel()
  let difficultyLabel = UILabel()
  let nameTextField = UITextField()
  var selectedImage: UIImage?
  let avatarImageView = UIImageView()
  var difficultySegmentedControl = UISegmentedControl()
  
  // MARK: - lifecycle funcs
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    UserDefaults.standard.set(nameTextField.text, forKey: "UserName")
    saveAvatar()
  }
  
  // MARK: - flow funcs
  
  private func configureUI() {
    view.backgroundColor = .systemPink
    navigationItem.hidesBackButton = true
    createBackButton()
    createColorButton()
    chooserColorLabelCreate()
    enterNameFieldCreate()
    createChooserAvatars()
    chooserDifficulty()
    pickerCreate()
  }
  
  private func createBackButton() {
    let backButton = UIBarButtonItem(image: UIImage(systemName: Constants.backButtonSymbol, withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.backButtonSize)), style: .plain, target: self, action: #selector(backButtonPressed))
    backButton.tintColor = .black
    navigationItem.leftBarButtonItem = backButton
  }
  
  @objc func backButtonPressed() {
    navigationController?.popViewController(animated: true)
  }
  
  private func pickerCreate() {
    pickerView = UIPickerView(frame: CGRect(x: 0, y: Constants.screen.height * 0.75, width: Constants.screen.width, height: Constants.screen.height / 4))
    pickerView.backgroundColor = .white
    pickerView.delegate = self
    pickerView.dataSource = self
    pickerView.isHidden = true
    view.addSubview(pickerView)
    if let savedColor = UserDefaultsManager.shared.color(forKey: "SelectedColor"), let selectedIndex = colors.firstIndex(of: savedColor) {
      pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
      updateColorButtonTitle()
    }
  }
  
  private func createColorButton() {
    colorButton.frame = CGRect(x: Constants.screen.width / 2, y: Constants.screen.height / 8, width: Constants.screen.width / 2, height: Constants.screen.height / 10)
    colorButton.setTitle("Select Color", for: .normal)
    colorButton.titleLabel?.font = UIFont(name: Constants.font, size: Constants.fontSize)
    colorButton.setTitleColor(.black, for: .normal)
    colorButton.addTarget(self, action: #selector(showColorPicker), for: .touchUpInside)
    view.addSubview(colorButton)
  }
  
  private func chooserColorLabelCreate (){
    chooseColorLabel.frame = CGRect(x: Constants.screen.width / 10, y: Constants.screen.height / 8, width: Constants.screen.width / 2, height: Constants.screen.height / 10)
    chooseColorLabel.text = "Color of car: "
    chooseColorLabel.font = UIFont(name: Constants.font, size: Constants.fontSize)
    view.addSubview(chooseColorLabel)
  }
  
  private func updateColorButtonTitle() {
    if let selectedRow = pickerView?.selectedRow(inComponent: 0) {
      let selectedColor = colors[selectedRow]
      colorButton.setTitle(selectedColor.name, for: .normal)
    }
  }
  
  private func enterNameFieldCreate() {
    nameLabel.frame = CGRect(x: Constants.screen.width / 10, y: Constants.screen.height / 4, width: Constants.screen.width / 2, height: Constants.screen.height / 10)
    nameLabel.text = "Your Name:"
    nameLabel.font = UIFont(name: Constants.font, size: Constants.fontSize)
    view.addSubview(nameLabel)
    nameTextField.frame = CGRect(x: Constants.screen.width / 1.8, y: Constants.screen.height / 3.8, width: Constants.screen.width / 3, height: Constants.screen.height / 17)
    nameTextField.placeholder = "Enter your name"
    nameTextField.borderStyle = .roundedRect
    view.addSubview(nameTextField)
    
    if let savedName = UserDefaults.standard.string(forKey: "UserName") {
      nameTextField.text = savedName
    } else {
      nameTextField.text = "Default"
    }
  }
  
  private func createChooserAvatars() {
    avatarImageView.image = Constants.defaultAvatar
    avatarImageView.contentMode = .scaleAspectFit
    avatarImageView.frame = CGRect(x: Constants.screen.width / 3, y: Constants.screen.height / 2.5, width: Constants.screen.width / 3, height: Constants.screen.height / 10)
    view.addSubview(avatarImageView)
    pickAvatarButton.frame = CGRect(x: Constants.screen.width / 3, y: Constants.screen.height / 1.9, width: Constants.screen.width / 3, height: Constants.screen.height / 15)
    pickAvatarButton.setTitle("Pick Avatar", for: .normal)
    pickAvatarButton.backgroundColor = .black
    pickAvatarButton.layer.cornerRadius = 20
    pickAvatarButton.addTarget(self, action: #selector(pickAvatar), for: .touchUpInside)
    view.addSubview(pickAvatarButton)
    
    if let fileName = UserDefaults.standard.string(forKey: "UserAvatarFileName") {
      if let loadedImage = imageManager.loadImage(from: fileName) {
        selectedImage = loadedImage
        avatarImageView.image = loadedImage
      }
    } else {
      avatarImageView.image = Constants.defaultAvatar
    }
  }
  
  private func chooserDifficulty() {
    difficultyLabel.frame = CGRect(x: (Constants.screen.width / 2 - ((Constants.screen.width / 3) / 2)) , y: Constants.screen.height / 1.4, width: Constants.screen.width / 3, height: 30)
    difficultyLabel.text = "Difficulty"
    difficultyLabel.font = UIFont(name: Constants.font, size: Constants.fontSize)
    view.addSubview(difficultyLabel)
    difficultySegmentedControl = UISegmentedControl(items: ["Easy", "Medium", "Hard"])
    difficultySegmentedControl.frame = CGRect(x: Constants.screen.width / 10, y: Constants.screen.height / 1.3, width: Constants.screen.width * 0.8, height: 30)
    difficultySegmentedControl.selectedSegmentIndex = 0
    difficultySegmentedControl.addTarget(self, action: #selector(difficultyChanger), for: .valueChanged)
    view.addSubview(difficultySegmentedControl)
    
    let savedDifficultyIndex = UserDefaults.standard.integer(forKey: "Difficulty")
    difficultySegmentedControl.selectedSegmentIndex = savedDifficultyIndex
  }
  
  @objc func showColorPicker() {
    pickerView.isHidden = !pickerView.isHidden
  }
  
  @objc func pickAvatar() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    present(picker, animated: true, completion: nil)
  }
  
  @objc func saveAvatar() {
    guard let avatarToSave = selectedImage ?? Constants.defaultAvatar else { return }
    do {
      if let savedName = try imageManager.saveImage(avatarToSave) {
        UserDefaults.standard.set(savedName, forKey: "UserAvatarFileName")
      } else {
        print("error loading")
      }
    } catch {
      print("error loading")
    }
  }
  
  @objc func difficultyChanger() {
    let selectedIndex = difficultySegmentedControl.selectedSegmentIndex
    UserDefaults.standard.set(selectedIndex, forKey: "Difficulty")
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true, completion: nil)
    guard let image = info[.editedImage] as? UIImage else {return}
    selectedImage = image
    avatarImageView.image = image
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return colors.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let color = colors[row]
    return color.name
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let selectedColor = colors[row]
    UserDefaultsManager.shared.setColor(selectedColor, forKey: "SelectedColor")
    delegate?.didSelectColor(selectedColor)
    
    updateColorButtonTitle()
  }
}

//MARK: - extensions

private extension UIColor {
  var name: String {
    switch self {
    case .black: return "Black"
    case .yellow: return "Yellow"
    case .green: return "Green"
    case .red: return "Red"
    case .purple: return "Purple"
    case .blue: return "Blue"
    default: return "Unknown"
    }
  }
}
