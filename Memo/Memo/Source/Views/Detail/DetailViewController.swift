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

protocol DetailViewBindable {
    var viewWillAppear: PublishRelay<Int> { get }
    var memoData: Signal<Memo> { get }
}

final class DetailViewController: ViewController<DetailViewBindable> {
    typealias UI = Constants.UI.Detail

    let scrollView = UIScrollView()
    var id: Int?
    
    override func bind(_ viewModel: DetailViewBindable) {
        self.disposeBag = DisposeBag()
        
        self.rx.viewWillAppear
            .take(1)
            .map { [weak self] _ in self?.id }
            .filterNil()
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)
        
        viewModel.memoData
            .emit(onNext: { [weak self] memo in
                self?.buildMemoBoard(data: memo)
            })
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        view.backgroundColor = .white
        buildEditButton()
    }
}

extension DetailViewController {
    private func buildEditButton() {
        let eidtButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = eidtButton
        eidtButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let editViewController = EditViewController()
                self?.navigationController?.pushViewController(editViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func buildMemoBoard(data: Memo) {
        let titleView = buildTitleView(text: data.title)
        let descriptionView = buildDescriptionView(text: data.description, topView: titleView)
        let imageList = buildImageSlider(imageList: data.imageList ?? [], topView: descriptionView)
        
        let contentsHeight = titleView.getEstimatedSize().height + descriptionView.getEstimatedSize().height + (UI.imageHeight + UI.imageMargin) * CGFloat(imageList.count) + UI.bottomMargin
        scrollView.contentSize = CGSize(width: view.frame.width, height: contentsHeight)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.height.bottom.equalToSuperview()
            $0.top.equalToSuperview()
        }
    }
    
    private func buildTitleView(text: String) -> UITextView {
        let titleView = UITextView()
        titleView.do {
            $0.font = UI.titleFont
            $0.text = text
            $0.isEditable = false
            $0.setAutoHeight(disposeBag: disposeBag)
        }
        scrollView.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.leading.top.width.equalToSuperview()
        }
        
        return titleView
    }
    
    private func buildDescriptionView(text: String, topView: UIView) -> UITextView {
        let descriptionView = UITextView()
        descriptionView.do {
            $0.font = UI.descriptionFont
            $0.text = text
            $0.isEditable = false
            $0.setAutoHeight(disposeBag: disposeBag)
        }
        scrollView.addSubview(descriptionView)
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.width.equalToSuperview()
        }
        
        return descriptionView
    }
    
    private func buildImageSlider(imageList: [String], topView: UIView) -> [UIImageView]{
        var imageViewList: [UIImageView] = []
        for i in 0..<imageList.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.kf.setImage(with: URL(string: imageList[i]), placeholder: UIImage(named: "placeholder"))
            scrollView.addSubview(imageView)
            imageView.snp.makeConstraints {
                $0.top.equalTo(topView.snp.bottom).offset(UI.imageHeight * CGFloat(i) + UI.imageMargin * CGFloat(i+1))
                $0.height.equalTo(UI.imageHeight)
                $0.leading.width.equalToSuperview().inset(UI.imageMargin)
            }
            imageViewList.append(imageView)
        }
        
        return imageViewList
    }
}
