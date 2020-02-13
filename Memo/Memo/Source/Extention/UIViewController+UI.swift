//
//  UIViewController+UI.swift
//  Memo
//
//  Created by 김효원 on 13/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit

extension UIViewController {
    func buildBtmToolbar(items: [UIBarButtonItem]) -> UIToolbar {
        let toolBar = MToolbar()
        toolBar.setItems(items, animated: true)
        
        view.addSubview(toolBar)
        var bottom: CGFloat = 0
        if #available(iOS 11.0, *) { bottom = Constants.UI.Base.safeAreaInsetsTop }
        toolBar.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(bottom)
            $0.height.equalTo(Constants.UI.Base.toolBarHeight)
        }
        
        return toolBar
    }
}
