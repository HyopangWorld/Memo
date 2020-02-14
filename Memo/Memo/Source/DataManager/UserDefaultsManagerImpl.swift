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
    private let dummyData = Memo(id: -1, title: "", description: "", imageList: [])
    
    func getMemoList() -> [Memo]? {
        guard let list = UserDefaults.standard.dictionary(forKey: memoKey) else { return nil }
        
        return parseListToMemo(list: list)
    }
    
    func getMemo(id: Int) -> Memo? {
        return getMemoList()?.filter { $0.id == id }.first
    }
    
    func removeMemo(id: Int) -> [Memo]? {
        guard var list = UserDefaults.standard.dictionary(forKey: memoKey) else { return nil }
        list.removeValue(forKey: "\(id)")
        UserDefaults.standard.set(list, forKey: memoKey)
        UserDefaults.standard.synchronize()
        
        return parseListToMemo(list: list)
    }
    
    func updateMemo(memo: Memo) -> [Memo]? {
        var list = Dictionary<String, Any>()
        if let data = UserDefaults.standard.dictionary(forKey: memoKey) { list = data }
        list.updateValue(parseMemoToList(memo: memo), forKey: "\(memo.id)")
        UserDefaults.standard.set(list, forKey: memoKey)
        UserDefaults.standard.synchronize()
        
        return parseListToMemo(list: list)
    }
    
    func createId() -> Int {
        guard let list = UserDefaults.standard.dictionary(forKey: memoKey) else { return 1 }
        return list.count + 1
    }
}

extension UserDefaultsManagerImpl {
    private func parseListToMemo(list: Dictionary<String, Any>) -> [Memo] {
        return list.values.map { dictionary -> Memo in
            guard let memo = dictionary as? Dictionary<String, Any> else { return dummyData }
            
            return Memo(id: memo["id"] as? Int ?? -1,
                        title: memo["title"] as? String ?? "",
                        description: memo["description"] as? String ?? "",
                        imageList: memo["imageList"] as? [String] ?? [])
        }
    }
    
    private func parseMemoToList(memo: Memo) -> Dictionary<String, Any> {
        return [ "id": memo.id,
                 "title": memo.title,
                 "description": memo.description,
                 "imageList": memo.imageList ?? [] ]
    }
}
