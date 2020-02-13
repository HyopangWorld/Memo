//
//  DetailViewModel.swift
//  Memo
//
//  Created by 김효원 on 12/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import RxSwift
import RxCocoa

struct DetailViewModel: DetailViewBindable {
    let viewDidLoad = PublishRelay<Int>()
    let deleteData = PublishRelay<Int>()
    let memoData: Signal<Memo>
    let memoDeleted: Signal<[Memo]>
    
    init(model: DetailModel = DetailModel()) {
        memoData = viewDidLoad
            .map(model.getMemo(id:))
            .filterNil()
            .asSignal(onErrorSignalWith: .empty())

        memoDeleted = deleteData
            .map(model.deleteMemo(id:))
            .filterNil()
            .asSignal(onErrorSignalWith: .empty())
    }
}
