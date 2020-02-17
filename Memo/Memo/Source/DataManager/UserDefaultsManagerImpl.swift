//
//  UserDefaultsManagerImpl.swift
//  Memo
//
//  Created by 김효원 on 11/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation

struct UserDefaultsManagerImpl: UserDefaultsManager {
    private let memoKey = "Memo"
    private let dummyData = Memo(date: Date(), title: "", description: "", imageList: [])

    
    func getMemoList() -> [Memo]? {
        guard let list = UserDefaults.standard.dictionary(forKey: memoKey) else { return nil }
        
        return parseListToMemo(list: list)
    }
    
    func getMemo(date: Date) -> Memo? {
        return getMemoList()?.filter { $0.date == date }.first
    }
    
    func removeMemo(date: Date) -> [Memo]? {
        guard var list = UserDefaults.standard.dictionary(forKey: memoKey) else { return nil }
        list.removeValue(forKey: "\(date)")
        UserDefaults.standard.set(list, forKey: memoKey)
        UserDefaults.standard.synchronize()
        
        return parseListToMemo(list: list)
    }
    
    func updateMemo(memo: Memo) -> [Memo]? {
        var list = Dictionary<String, Any>()
        if let data = UserDefaults.standard.dictionary(forKey: memoKey) { list = data }
        list.updateValue(parseMemoToList(memo: memo), forKey: "\(memo.date)")
        UserDefaults.standard.set(list, forKey: memoKey)
        UserDefaults.standard.synchronize()
        
        return parseListToMemo(list: list)
    }
    
    func getDate() -> Date {
        return Date()
    }
}

extension UserDefaultsManagerImpl {
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
