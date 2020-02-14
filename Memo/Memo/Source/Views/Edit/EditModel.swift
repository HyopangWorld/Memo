//
//  EditModel.swift
//  Memo
//
//  Created by 김효원 on 14/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation

struct EditModel {
    let userDefaultsManager: UserDefaultsManager
    
    init(userDefaultsManager: UserDefaultsManager = UserDefaultsManagerImpl()) {
        self.userDefaultsManager = userDefaultsManager
    }
    
    func saveMemo(memo: Memo) -> [Memo]? {
        return userDefaultsManager.updateMemo(memo: memo)
    }
    
    func createMemo() -> Memo {
        return Memo(id: userDefaultsManager.createId(),
                    title: "",
                    description: "",
                    imageList: [])
    }
}
