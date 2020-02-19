//
//  EditTests.swift
//  MemoTests
//
//  Created by 김효원 on 19/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import XCTest
import RxSwift

@testable import Memo

class EditTests: XCTestCase {
    let disposeBag = DisposeBag()
    let dataManager = MockUpUserDefaultsManager()
    var viewModel: EditViewModel!
    var model: EditModel!

    override func setUp() {
        self.model = EditModel(userDefaultsManager: dataManager)
        self.viewModel = EditViewModel(model: model)
    }

    func testSaveMemo() {
        let memoList = model.saveMemo(memo: MemoDummyData.memoData)
        assert(memoList?.contains(where: { $0.date == MemoDummyData.memoData.date }) ?? false, "Memo Update & Save Success")
    }
    
    func testCreateMemo() {
        let newMemo = model.createMemo()
        let now = Date()
        assert(newMemo.date == now, "Memo Create Success")
    }
    
    func testGetAndParse() {
        viewModel.saveMemo
            .emit(onNext: { data in
                guard let memo = data.first else { return }
                assert(memo.date == MemoDummyData.memoData.date)
            })
            .disposed(by: disposeBag)
        
        viewModel.saveData.accept(MemoDummyData.memoData)
    }
}
