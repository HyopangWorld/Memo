//
//  Constants.swift
//  Memo
//
//  Created by 김효원 on 10/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation
import UIKit

public struct Constants {
    struct UI {
        struct Base {
            @available(iOS 11.0, *)
            static let safeAreaInsetsTop: CGFloat = (UIApplication.shared.windows.first { $0.isKeyWindow })?.safeAreaInsets.top ?? 0
            static let toolbarColor: UIColor = .white
            static let toolBarHeight: CGFloat = 50
            static let lineHeight: CGFloat = 1
        }
        
        struct IndexCell {
            static let height: CGFloat = 65
            static let sideMargin: CGFloat = 20
            
            static let titleFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
            static let titleTopMargin: CGFloat = 5
            
            static let descriptFont: UIFont = .systemFont(ofSize: 15, weight: .light)
            static let descriptColor: UIColor = UIColor(displayP3Red: (180/255), green: (180/255), blue: (180/255), alpha: 1)
            static let descriptTopMargin: CGFloat = 5
            
            static let thumbLeftMargin: CGFloat = 10
            static let thumbSize: CGFloat = 55
        }
        
        struct Detail {
            static let backgroundColor: UIColor = UIColor(displayP3Red: (245/255), green: (245/255), blue: (245/255), alpha: 1)
            static let btmMargin: CGFloat = 20
            static let titleFont: UIFont = .systemFont(ofSize: 23, weight: .bold)
            static let descriptionFont: UIFont = .systemFont(ofSize: 15, weight: .regular)
            static let imageHeight: CGFloat = 200
            static let imageMargin: CGFloat = 10
        }
    }
    
    struct Text {
        struct Index {
            static let title: String = "메모".localizedCapitalized
        }
    }
}
