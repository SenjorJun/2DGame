//
//  Imagemanager.swift
//  2DGame
//
//  Created by Сергей Соловьёв on 26.02.2024.
//

import Foundation
import UIKit

final class ImageManager {
    func saveImage(_ image: UIImage) throws -> String? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let name = UUID().uuidString
        let fileURL = directory.appendingPathComponent(name).appendingPathExtension("jpg")
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        try data.write(to: fileURL)
        return name
    }
    
    func loadImage(from fileName: String) -> UIImage? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = directory.appendingPathComponent(fileName).appendingPathExtension("jpg")
        let image = UIImage(contentsOfFile: fileURL.path)
        return image
    }
}
