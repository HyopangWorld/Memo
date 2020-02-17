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
import RxGesture
import Kingfisher
import SnapKit
import Then

protocol DetailViewBindable {
    var viewDidLoad: PublishRelay<Int> { get }
    var deleteData: PublishRelay<Int> { get }
    var memoData: Signal<Memo> { get }
    var memoDeleted: Signal<[Memo]> { get }
}

final class DetailViewController: ViewController<DetailViewBindable> {
    typealias UI = Constants.UI.Detail
    
    let scrollView = UIScrollView()
    var id: Int?
    
    override func bind(_ viewModel: DetailViewBindable) {
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        
        self.rx.viewDidLoad
            .map { [weak self] _ in self?.id }
            .filterNil()
            .bind(to: viewModel.viewDidLoad)
            .disposed(by: disposeBag)
        
        viewModel.memoData
            .emit(onNext: { [weak self] memo in
                guard let alert = self?.buildAlert() else { return }
                guard let btmView = self?.buildToolbar(alert: alert, data: memo) else { return }
                self?.buildMemoBoard(btmView: btmView, data: memo)
            })
            .disposed(by: disposeBag)
        
        viewModel.memoDeleted
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        view.backgroundColor = .white
    }
}

extension DetailViewController {
    private func buildAlert() -> UIAlertController {
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let id = self?.id else { return }
            self?.viewModel?.deleteData.accept(id)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        return alert
    }
    
    private func buildToolbar(alert: UIAlertController, data: Memo) -> UIView {
        let trashBtn = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let editBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: nil)
        trashBtn.rx.tap
            .subscribe(onNext: { [weak self] id in
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        editBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let editViewController = EditViewController()
                let editViewModel = EditViewModel()
                editViewController.memo = data
                editViewController.bind(editViewModel)
                self?.navigationController?.pushViewController(editViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        return buildBtmToolbar(items: [trashBtn, centerSpace, editBtn])
    }
    
    private func buildMemoBoard(btmView: UIView, data: Memo) {
        let titleView = buildTitleView(text: data.title)
        let descriptionView = buildDescriptionView(text: data.description, topView: titleView)
        let imageList = buildImageSlider(imageList: data.imageList ?? [], topView: descriptionView)
        let contentsHeight = titleView.getEstimatedSize().height + descriptionView.getEstimatedSize().height + (UI.imageHeight + UI.imageMargin) * CGFloat(imageList.count) + UI.btmMargin
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: contentsHeight)
        if #available(iOS 11.0, *) { }
        else {
            scrollView.contentInset = UIEdgeInsets.init(top: self.getTopAreaHeight(), left: 0, bottom: 0, right: 0)
            scrollView.setContentOffset(CGPoint(x: 0, y: -self.getTopAreaHeight()), animated: false)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(btmView.snp.top)
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
