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
        toolBar.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(self.getNochiHeight())
            $0.height.equalTo(Constants.UI.Base.toolBarHeight)
        }
        
        return toolBar
    }
    
    func showNotice(noti: String) {
        let notice = UIAlertController(title: noti, message: nil, preferredStyle: .alert)
        notice.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        self.present(notice, animated: true, completion: nil)
    }
}
