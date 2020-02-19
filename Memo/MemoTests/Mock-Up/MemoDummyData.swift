//
//  MemoDummyData.swift
//  MemoTests
//
//  Created by 김효원 on 19/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import Foundation

@testable import Memo

struct MemoDummyData {
    static let memoDataList: [String:Any] = [
        "\(Date(timeIntervalSince1970: 86400))" : [
            "date": Date(timeIntervalSince1970: 86400),
            "title": "제목2",
            "description": "본문2",
            "imageList": ["https://lh3.googleusercontent.com/proxy/k25Zs0s_Vx-pz1LYN0-9XzGt4fZyVG6X81_W3UPlK7NjrUbv8zr1IXFOHeQercbGFYCJxQl0P6RDfrIbqbSYfrQriVitbyDa4YpHY2Fa8OXGswlU68WyujmjXC2Yx7N4-Io4smYJns_MMA"]
        ],
        "\(Date(timeIntervalSince1970: 86405))" : [
            "date": Date(timeIntervalSince1970: 86405),
            "title": "제목3",
            "description": "본문3",
            "imageList": ["https://lh3.googleusercontent.com/proxy/k25Zs0s_Vx-pz1LYN0-9XzGt4fZyVG6X81_W3UPlK7NjrUbv8zr1IXFOHeQercbGFYCJxQl0P6RDfrIbqbSYfrQriVitbyDa4YpHY2Fa8OXGswlU68WyujmjXC2Yx7N4-Io4smYJns_MMA"]
        ]
    ]
    
    static let memoData: Memo = Memo(date: Date(timeIntervalSince1970: 86410),
                                     title: "제목1",
                                     description: "본문1",
                                     imageList: ["https://lh3.googleusercontent.com/proxy/k25Zs0s_Vx-pz1LYN0-9XzGt4fZyVG6X81_W3UPlK7NjrUbv8zr1IXFOHeQercbGFYCJxQl0P6RDfrIbqbSYfrQriVitbyDa4YpHY2Fa8OXGswlU68WyujmjXC2Yx7N4-Io4smYJns_MMA"])
}
