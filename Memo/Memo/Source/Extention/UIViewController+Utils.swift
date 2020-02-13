//
//  UIViewController+Utils.swift
//  Memo
//
//  Created by 김효원 on 13/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit

extension UIViewController {
    func getTopAreaHeight() -> CGFloat {
        var height: CGFloat = navigationController?.navigationBar.frame.height ?? 0
        if #available(iOS 11.0, *) { height += Constants.UI.Base.safeAreaInsetsTop  }
        else { height += UIApplication.shared.statusBarFrame.size.height }
        
        return height
    }
}
