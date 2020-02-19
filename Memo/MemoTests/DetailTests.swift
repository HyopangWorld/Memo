//
//  DetailTests.swift
//  MemoTests
//
//  Created by 김효원 on 19/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import XCTest
import RxSwift

@testable import Memo

class DetailTests: XCTestCase {
    let disposeBag = DisposeBag()
    let dataManager = MockUpUserDefaultsManager()
    var viewModel: DetailViewModel!
    var model: DetailModel!

    override func setUp() {
        self.model = DetailModel(userDefaultsManager: dataManager)
        self.viewModel = DetailViewModel(model: model)
    }

    func testGetMemo() {
        let memo = model.getMemo(date: Date(timeIntervalSince1970: 86400))
        assert(memo != nil, "Memo Getting Success")
    }
    
    func testDeleteMemo() {
        let date = Date(timeIntervalSince1970: 86400)
        let memoList = model.deleteMemo(date: date)
        assert(!(memoList?.contains(where: { $0.date == date }) ?? false), "Memo Delete Success")
    }
    
    func testGetAndParse() {
        viewModel.memoData
            .emit(onNext: { data in
                assert(data.date == Date(timeIntervalSince1970: 86400))
            })
            .disposed(by: disposeBag)
        
        viewModel.viewDidLoad.accept(Date(timeIntervalSince1970: 86400))
    }
}
