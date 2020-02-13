//
//  UITextView+UItils.swift
//  Memo
//
//  Created by 김효원 on 12/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UITextView {
    func setAutoHeight(disposeBag: DisposeBag) {
        self.isScrollEnabled = false
        self.rx.didChange.startWith(Void())
            .subscribe(onNext: { _ in
                let estimatedSize = self.getEstimatedSize()
                self.constraints.forEach { constraint in
                    if constraint.firstAttribute == .height {
                        constraint.constant = estimatedSize.height
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func getEstimatedSize() -> CGSize {
        let size = CGSize(width: self.frame.width, height: .infinity)
        
        return self.sizeThatFits(size)
    }
}
