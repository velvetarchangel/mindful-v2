//
//  Image.swift
//  mindful2
//
//  Created by Himika Dastidar on 2020-11-06.
// Source https://programmingwithswift.com/easily-conform-to-codable/

import Foundation
import UIKit

struct Image: Codable{
    let imageData: Data?
    
    init(withImage image: UIImage) {
        self.imageData = image.pngData()
    }

    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        let image = UIImage(data: imageData)
        
        return image
    }
}
