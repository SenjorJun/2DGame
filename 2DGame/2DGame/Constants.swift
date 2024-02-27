//
//  Constants.swift
//  2DGame
//
//  Created by Сергей Соловьёв on 14.02.2024.
//

import Foundation
import UIKit

enum Constants{
    static let screen = UIScreen.main.bounds
    static let heightButton: CGFloat = Constants.screen.height/10
    static let widthButton = Constants.screen.width / 1.5
    static let cornerRadiusOfButton: CGFloat = 20
    static let widthCar: CGFloat = 70
    static let heightCar: CGFloat = 120
    static let widthStrip: CGFloat = 10
    static let heightMiddleStrip: CGFloat = 10
    static let stripTimerValue: TimeInterval = 0.2
    static let defaultAvatar = UIImage(named: "defaultAvatar")
    static let font = "HelveticaNeue-Bold"
    static let fontSize: CGFloat = 25
    static let speedOfRoadStrips: TimeInterval = 1
    static let speedOfTrees: TimeInterval = 2
    static let speedOfMovement: TimeInterval = 0.3
    static let backButtonSymbol = "chevron.left"
    static let backButtonSize: CGFloat = 15
}

