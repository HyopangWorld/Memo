//
//  DetailViewController.swift
//  Memo
//
//  Created by 김효원 on 11/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAppState
import Kingfisher
import SnapKit
import Then

protocol DetailViewBindable { }

final class DetailViewController: ViewController<DetailViewBindable> {
    typealias UI = Constants.UI.Detail
    
    var id: Int?
    
    override func bind(_ viewModel: DetailViewBindable) {
        self.disposeBag = DisposeBag()
    }
    
    override func layout() {
        view.backgroundColor = .white
        let eidtButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = eidtButton
        eidtButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let editViewController = EditViewController()
                self?.navigationController?.pushViewController(editViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        buildMemoBoard()
    }
}

extension DetailViewController {
    private func buildMemoBoard() {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        var height: CGFloat = navigationController?.navigationBar.frame.height ?? 0
        if #available(iOS 11.0, *) { height += Constants.UI.Base.safeAreaInsetsTop  }
        else {
            height += UIApplication.shared.statusBarFrame.size.height
            scrollView.contentInset = UIEdgeInsets.init(top: -height, left: 0, bottom: 0, right: 0)
        }
        scrollView.snp.makeConstraints {
            $0.leading.trailing.height.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(height)
        }
        
        let titleView = UITextView()
        titleView.do {
            $0.font = UI.titleFont
            $0.text = "Title"
            $0.isEditable = false
            $0.setAutoHeight(disposeBag: disposeBag)
        }
        scrollView.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.leading.top.width.equalToSuperview()
        }
        
        let descriptionView = UITextView()
        descriptionView.do {
            $0.font = UI.descriptionFont
            $0.text = "Comment"
            $0.isEditable = false
            $0.setAutoHeight(disposeBag: disposeBag)
        }
        scrollView.addSubview(descriptionView)
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.width.equalToSuperview()
        }
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.kf.setImage(with: URL(string: ""), placeholder: UIImage(named: "placeholder"))
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.equalTo(descriptionView.snp.bottom)
            $0.leading.width.equalToSuperview().inset(UI.imageMargin)
        }
    }
}
