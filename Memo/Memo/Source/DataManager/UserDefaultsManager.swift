//
//  UserDefaultsManager.swift
//  Memo
//
//  Created by 김효원 on 11/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation

protocol UserDefaultsManager {
    func getMemoList() -> [Memo]?
    func getMemo(date: String) -> Memo?
    func removeMemo(date: String) -> [Memo]?
    func updateMemo(memo: Memo) -> [Memo]?
    func getDate() -> String
}
