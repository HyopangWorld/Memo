//
//  UIViewController+Utils.swift
//  Memo
//
//  Created by 김효원 on 13/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
    func getTopAreaHeight() -> CGFloat {
        return (UIApplication.shared.statusBarFrame.size.height + (navigationController?.navigationBar.frame.height ?? 0))
    }
    
    func setTouchEndEditing(disposeBag: DisposeBag) {
        view.rx.tapGesture()
            .subscribe(onNext: { [weak self] _ in self?.view.endEditing(true) })
            .disposed(by: disposeBag)
    }
    
    func getNochiHeight() -> CGFloat {
        if #available(iOS 11.0, *) {
            return Constants.UI.Base.safeAreaInsetsTop >= 44 ? Constants.UI.Base.safeAreaInsetsTop : 0
        }
        
        return 0
    }
}
