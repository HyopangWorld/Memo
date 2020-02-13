//
//  IndexCell.swift
//  Memo
//
//  Created by 김효원 on 10/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher
import Then

class MemoListCell: UITableViewCell {
    typealias Data = (id: Int, thumbnail: String?, title: String, description: String)
    typealias UI = Constants.UI.IndexCell

    let thumbnailView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()

    var id: Int?
    
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(data: Data) {
        id = data.id
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        if let url = data.thumbnail {
            thumbnailView.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "placeholder"))
        }
    }
    
    private func layout() {
        titleLabel.font = UI.titleFont
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(UI.sideMargin)
            $0.top.equalToSuperview().inset(UI.titleTopMargin)
            $0.height.equalToSuperview().dividedBy(2)
            $0.width.equalTo(self.frame.width - UI.thumbSize - UI.thumbLeftMargin - (UI.sideMargin * 2))
        }
        
        descriptionLabel.font = UI.descriptFont
        descriptionLabel.textColor = UI.descriptColor
        self.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(UI.sideMargin)
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalToSuperview().inset(UI.descriptTopMargin)
            $0.width.equalTo(self.frame.width - UI.thumbSize - UI.thumbLeftMargin - (UI.sideMargin * 2))
        }
        
        thumbnailView.contentMode = .scaleToFill
        self.addSubview(thumbnailView)
        thumbnailView.snp.updateConstraints {
            $0.trailing.equalToSuperview().inset(UI.sideMargin)
            $0.leading.equalTo(descriptionLabel.snp.trailing).offset(UI.thumbLeftMargin)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(UI.thumbSize)
        }
    }
}
