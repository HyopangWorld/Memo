//
//  MemoTests.swift
//  MemoTests
//
//  Created by 김효원 on 10/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import XCTest
import RxSwift

@testable import Memo

class IndexTests: XCTestCase {
    let disposeBag = DisposeBag()
    let dataManager = MockUpUserDefaultsManager()
    var viewModel: IndexViewModel!
    var model: IndexModel!
    
    override func setUp() {
        self.model = IndexModel(userDefaultsManager: dataManager)
        self.viewModel = IndexViewModel(model: model)
    }
    
    func testGetMemoList() {
        let memoList = model.getMemoList()
        assert(memoList != nil, "Memo List Getting Success")
    }
    
    func testDeleteMemo() {
        let date = Date(timeIntervalSince1970: 86400)
        let memoList = model.deleteMemo(date: date)
        assert(!(memoList?.contains(where: { $0.date == date }) ?? false), "Memo Delete Success")
    }
    
    func testParseData() {
        guard let memoList = model.getMemoList() else { return }
        let parsedData = model.parseMemo(memoList: memoList)
        assert(parsedData.first?.date == Date(timeIntervalSince1970: 86405), "Memo Cell Date Parsing Success")
    }
    
    func testGetAndParse() {
        viewModel.cellData
            .drive(onNext: { (data) in
                guard let memo = data.first else { return }
                assert(memo.date == Date(timeIntervalSince1970: 86405))
            })
            .disposed(by: disposeBag)
        
        viewModel.viewWillAppear.accept(Void())
    }
}
