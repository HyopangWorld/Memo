//
//  MockUpUserDefaultsManager.swift
//  MemoTests
//
//  Created by 김효원 on 19/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation

@testable import Memo

struct MockUpUserDefaultsManager: UserDefaultsManager {
    private let memoKey = "Memo"
    private let dummyData = Memo(date: Date(), title: "", description: "", imageList: [])

    func getMemoList() -> [Memo]? {
        let list = MemoDummyData.memoDataList
        
        return parseListToMemo(list: list)
    }
    
    func getMemo(date: Date) -> Memo? {
        return getMemoList()?.filter { $0.date == date }.first
    }
    
    func removeMemo(date: Date) -> [Memo]? {
        var list = MemoDummyData.memoDataList
        list.removeValue(forKey: "\(date)")
        
        return parseListToMemo(list: list)
    }
    
    func updateMemo(memo: Memo) -> [Memo]? {
        var list = MemoDummyData.memoDataList
        list.updateValue(parseMemoToList(memo: memo), forKey: "\(memo.date)")
        
        return parseListToMemo(list: list)
    }
    
    func getDate() -> Date {
        return Date()
    }
}

extension MockUpUserDefaultsManager {
    private func parseListToMemo(list: Dictionary<String, Any>) -> [Memo] {
        return list.values.map { dictionary -> Memo in
            guard let memo = dictionary as? Dictionary<String, Any> else { return dummyData }
            
            return Memo(date: memo["date"] as? Date ?? Date(),
                        title: memo["title"] as? String ?? "",
                        description: memo["description"] as? String ?? "",
                        imageList: memo["imageList"] as? [String] ?? [])
        }
    }
    
    private func parseMemoToList(memo: Memo) -> Dictionary<String, Any> {
        return [ "date": memo.date,
                 "title": memo.title,
                 "description": memo.description,
                 "imageList": memo.imageList ?? [] ]
    }
}
