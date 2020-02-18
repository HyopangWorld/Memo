//
//  MToolbar.swift
//  Memo
//
//  Created by 김효원 on 13/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit

class MToolbar: UIToolbar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initalize() {
        self.backgroundColor = Constants.UI.Base.backgroundColor
        self.barTintColor = Constants.UI.Base.backgroundColor
        self.tintColor = Constants.UI.Base.foregroundColor
        buildLine()
    }
    
    private func buildLine() {
        let line = UIView()
        line.backgroundColor = UIColor(displayP3Red: (223/255), green: (223/255), blue: (223/255), alpha: (223/255))
        self.addSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(Constants.UI.Base.lineHeight)
            $0.trailing.leading.equalToSuperview()
            $0.top.equalTo(self.snp.top)
        }
    }
}
