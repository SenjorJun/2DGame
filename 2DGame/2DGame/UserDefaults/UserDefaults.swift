//
//  UserDefaults.swift
//  2DGame
//
//  Created by Сергей Соловьёв on 20.02.2024.
//

import Foundation
import UIKit

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let userDefaults = UserDefaults.standard

    func saveRecord(_ record: Record) {
        var records = loadRecords()
        records.append(record)
        if let encodedData = try? JSONEncoder().encode(records) {
            userDefaults.set(encodedData, forKey: "records")
        }
    }

    func loadRecords() -> [Record] {
        if let savedData = userDefaults.data(forKey: "records"),
           let records = try? JSONDecoder().decode([Record].self, from: savedData) {
            return records
        } else {
            return []
        }
    }

    func setColor(_ color: UIColor?, forKey key: String) {
        guard let color = color else {
            userDefaults.removeObject(forKey: key)
            return
        }
        let data = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        userDefaults.set(data, forKey: key)
    }

    func color(forKey key: String) -> UIColor? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
    
  
}


