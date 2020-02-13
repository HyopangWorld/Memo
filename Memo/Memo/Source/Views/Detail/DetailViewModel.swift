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
    let viewWillAppear = PublishRelay<Int>()
    let memoData: Signal<Memo>
    
    init(model: DetailModel = DetailModel()) {
        memoData = viewWillAppear
            .map(model.getMemo(id:))
            .filterNil()
            .asSignal(onErrorSignalWith: .empty())
    }
}
