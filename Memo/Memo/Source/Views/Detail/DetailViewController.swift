//
//  DetailViewController.swift
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

protocol DetailViewBindable { }

final class DetailViewController: ViewController<DetailViewBindable> {
    
    var id: Int?
    
    override func bind(_ viewModel: DetailViewBindable) {
        self.disposeBag = DisposeBag()
    }
    
    override func layout() { }
}
