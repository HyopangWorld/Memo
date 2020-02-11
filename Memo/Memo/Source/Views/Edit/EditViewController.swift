//
//  EditViewController.swift
//  Memo
//
//  Created by 김효원 on 11/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAppState
import Then
import SnapKit

protocol EditViewBindable { }

final class EditViewController: ViewController<EditViewBindable> {
    
    override func bind(_ viewModel: EditViewBindable) {
        self.disposeBag = DisposeBag()
    }
    
    override func layout() { }
}
