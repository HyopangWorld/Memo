//
//  EditViewModel.swift
//  Memo
//
//  Created by 김효원 on 14/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import RxSwift
import RxCocoa

struct EditViewModel: EditViewBindable {
    let createMemo = PublishRelay<Void>()
    let saveData = PublishRelay<Memo>()
    let newMemo: Signal<Memo>
    let memoData: Signal<[Memo]>
    
    init(model: EditModel = EditModel()) {
        memoData = saveData
            .map(model.saveMemo(memo:))
            .filterNil()
            .asSignal(onErrorSignalWith: .empty())
        
        newMemo = createMemo
            .map{ _ in model.createMemo()}
            .asSignal(onErrorSignalWith: .empty())
    }
}
