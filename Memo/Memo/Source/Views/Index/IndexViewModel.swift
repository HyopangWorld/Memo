//
//  IndexViewModel.swift
//  Memo
//
//  Created by 김효원 on 10/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import RxSwift
import RxCocoa

struct IndexViewModel: IndexViewBindable {
    let viewWillAppear = PublishRelay<Void>()
    let cellData: Driver<[MemoListCell.Data]>
    let reloadList: Signal<Void>
    
    init(model: IndexModel = IndexModel()) {
        cellData = viewWillAppear
            .map(model.getMemoList)
            .asDriver(onErrorDriveWith: .empty())
        
        reloadList = viewWillAppear
            .map { _ in Void() }
            .asSignal(onErrorSignalWith: .empty())
    }
}
