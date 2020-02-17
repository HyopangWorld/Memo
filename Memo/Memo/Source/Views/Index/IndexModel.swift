//
//  IndexModel.swift
//  Memo
//
//  Created by 김효원 on 10/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation
import RxSwift

struct IndexModel {
    let userDefaultsManager: UserDefaultsManager
    
    init(userDefaultsManager: UserDefaultsManager = UserDefaultsManagerImpl()) {
        self.userDefaultsManager = userDefaultsManager
    }
    
    func getMemoList() -> [Memo]? {
        return userDefaultsManager.getMemoList()
    }
    
    func deleteMemo(date: Date) -> [Memo]? {
        return userDefaultsManager.removeMemo(date: date)
    }
    
    func parseMemo(memoList: [Memo]) -> [MemoListCell.Data] {
        return sortAsce(list: memoList).map { (date: $0.date,
                               thumbnail: $0.imageList?.first,
                               title: $0.title,
                               description: $0.description) }
    }
    
    private func sortDesc(list: [Memo]) -> [Memo] {
        return list.sorted { $0.date < $1.date }
    }
    
    private func sortAsce(list: [Memo]) -> [Memo] {
        return list.sorted { $0.date > $1.date }
    }
}
