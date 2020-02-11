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
    func getMemoList() -> [MemoListCell.Data] {
        return [(id: 0,
                 thumbnail: "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                 title: "제목",
                 description: "설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명")]
    }
}
