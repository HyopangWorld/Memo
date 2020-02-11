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
    
    func deleteMemo(id: Int) -> [Memo]? {
        return userDefaultsManager.removeMemo(id: id)
    }
    
    func parseMemo(memoList: [Memo]) -> [MemoListCell.Data] {
        return memoList.map { (id: $0.id,
                               thumbnail: $0.imageList.first ?? "",
                               title: $0.title,
                               description: $0.description) }
    }
}
