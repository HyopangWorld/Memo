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
    let deleteData = PublishRelay<Int>()
    let cellData: Driver<[MemoListCell.Data]>
    let reloadList: Signal<Void>
    
    init(model: IndexModel = IndexModel()) {
        let deleteMemo = deleteData
            .map(model.deleteMemo)
        
        let getMemo = viewWillAppear
            .map(model.getMemoList)
        
        cellData = Observable.merge(deleteMemo, getMemo)
            .filterNil()
            .map(model.parseMemo(memoList:))
            .asDriver(onErrorDriveWith: .empty())
        
        reloadList = Observable.merge(deleteMemo, getMemo)
            .map { _ in Void() }
            .asSignal(onErrorSignalWith: .empty())
    }
}
