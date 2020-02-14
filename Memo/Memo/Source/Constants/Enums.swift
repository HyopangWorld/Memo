//
//  Enums.swift
//  Memo
//
//  Created by 김효원 on 14/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation

enum PhotoType: String {
    case take = "take"
    case library = "library"
    case url = "url"
    
    func getPhotoTypeName() -> String {
        switch self {
        case .take:
            return "사진 찍기"
        case .library:
            return "사진 보관함"
        case .url:
            return "외부 URL"
        }
    }
}
