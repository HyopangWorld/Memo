//
//  ImageManagerImpl.swift
//  Memo
//
//  Created by 김효원 on 17/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation
import UIKit

struct ImageManagerImpl: ImageManager {
    static let shard: ImageManager = ImageManagerImpl()
    
    var documentsUrl: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    func loadImage(fileName: String) -> UIImage? {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        
        return nil
    }
    
    func saveImage(image: UIImage) -> String? {
        let fileName = "\(Date()).png"
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.jpegData(compressionQuality: 1.0) {
           try? imageData.write(to: fileURL, options: .atomic)
           return fileName
        }
        
        print("Error saving image")
        return nil
    }
}
