//
//  DetailModel.swift
//  Memo
//
//  Created by 김효원 on 12/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation

struct DetailModel {
    let userDefaultsManager: UserDefaultsManager
    
    init(userDefaultsManager: UserDefaultsManager = UserDefaultsManagerImpl()) {
        self.userDefaultsManager = userDefaultsManager
    }
    
    func getMemo(date: Date) -> Memo? {
        return userDefaultsManager.getMemo(date: date)
    }
    
    func deleteMemo(date: Date) -> [Memo]? {
        return userDefaultsManager.removeMemo(date: date)
    }
}
