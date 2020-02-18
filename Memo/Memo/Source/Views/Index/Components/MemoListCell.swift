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
    typealias CellData = (date: Date, thumbnail: String?, title: String, description: String)
    typealias UI = Constants.UI.IndexCell
    
    let titleLabel = UILabel()
    let timeLabel = UILabel()
    let descriptionLabel = UILabel()
    let thumbnailView = UIImageView()
    
    var date: Date?
    
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        timeLabel.text = nil
        descriptionLabel.text = nil
        thumbnailView.image = nil
    }
    
    func setData(data: CellData) {
        date = data.date
        timeLabel.text = parseDayOrTime(data.date)
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        if let thumbnail = data.thumbnail {
            if let image = ImageManagerImpl.shard.loadImage(fileName: thumbnail) {
                thumbnailView.image = image
                return
            }
            thumbnailView.kf.setImage(with: URL(string: thumbnail), placeholder: UIImage(named: "placeholder"))
        }
    }
    
    private func parseDayOrTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yyyy.MM.dd"
        if formatter.string(from: date) == formatter.string(from: Date()) {
            formatter.dateFormat = "a hh:mm"
        }
        
        return formatter.string(from: date)
    }
    
    private func layout() {
        self.backgroundColor = Constants.UI.Base.backgroundColor
        
        titleLabel.font = UI.titleFont
        self.addSubview(titleLabel)
        
        thumbnailView.contentMode = .scaleToFill
        self.addSubview(thumbnailView)
        thumbnailView.snp.updateConstraints {
            $0.trailing.equalToSuperview().inset(UI.sideMargin)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(UI.thumbSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(UI.sideMargin)
            $0.top.equalToSuperview().inset(UI.titleTopMargin)
            $0.height.equalToSuperview().dividedBy(2)
            $0.trailing.equalTo(thumbnailView.snp.leading).inset(UI.sideMargin)
        }
        
        timeLabel.font = UI.descriptFont
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(UI.sideMargin)
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalToSuperview().inset(UI.descriptTopMargin)
            $0.width.equalTo(UI.timeWidth)
        }
        
        descriptionLabel.font = UI.descriptFont
        descriptionLabel.textColor = UI.descriptColor
        self.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(timeLabel.snp.trailing)
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalToSuperview().inset(UI.descriptTopMargin)
            $0.trailing.equalTo(thumbnailView.snp.leading).inset(-UI.sideMargin)
        }
    }
}
