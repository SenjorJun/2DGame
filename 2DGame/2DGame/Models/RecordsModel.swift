//
//  RecordsModel.swift
//  2DGame
//
//  Created by Сергей Соловьёв on 26.02.2024.
//

import Foundation
import UIKit

struct Record: Codable {
    let playerName: String
    let date: Date
    let score: Int
    let avatarData: Data?
    
    init(playerName: String, date: Date, score: Int, avatarData: Data?) {
        self.playerName = playerName
        self.date = date
        self.score = score
        self.avatarData = avatarData
    }
    
    func getAvatarImage() -> UIImage? {
        guard let data = avatarData else {
            return nil
        }
        return UIImage(data: data)
    }
}
