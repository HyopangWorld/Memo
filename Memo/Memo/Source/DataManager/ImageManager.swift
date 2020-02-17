//
//  ImageManager.swift
//  Memo
//
//  Created by 김효원 on 17/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation
import UIKit

protocol ImageManager {
    var documentsUrl: URL { get }
    func loadImage(fileName: String) -> UIImage?
    func saveImage(image: UIImage) -> String?
}
