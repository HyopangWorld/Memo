//
//  EditViewController.swift
//  Memo
//
//  Created by 김효원 on 11/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAppState
import Then
import SnapKit

protocol EditViewBindable { }

final class EditViewController: ViewController<EditViewBindable> {
    typealias UI = Constants.UI.Edit
    
    let scrollView = UIScrollView()
    var id: Int?
    
    override func bind(_ viewModel: EditViewBindable) {
        self.disposeBag = DisposeBag()
    }
    
    override func layout() {
        view.backgroundColor = .white
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = doneBtn
        
        buildMemoBoard(data: nil)
    }
}

extension EditViewController {
    private func buildMemoBoard(data: Memo?) {
        let titleView = buildTitleView(text: data?.title ?? "")
        let descriptionView = buildDescriptionView(text: data?.description ?? "", topView: titleView)
        let imageSlider = buildImageSlider(imageList: data?.imageList ?? [], btmView: buildToolbar())
        
        scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.setContentOffset(.zero, animated: false)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(self.getTopAreaHeight())
            $0.bottom.equalTo(imageSlider.snp.top)
        }
        
        Observable.combineLatest(titleView.rx.didChange.startWith(Void()), descriptionView.rx.didChange.startWith(Void()))
            .subscribe(onNext: { [weak self] _ in
                let height = titleView.getEstimatedSize().height + descriptionView.getEstimatedSize().height + (UI.elmtMargin * 3)
                self?.scrollView.contentSize = CGSize(width: self?.view.frame.width ?? 0, height: height)
            })
            .disposed(by: disposeBag)
    }
    
    private func buildTitleView(text: String) -> UITextView {
        let titleView = UITextView()
        titleView.do {
            $0.font = UI.titleFont
            $0.text = text
            $0.setAutoHeight(disposeBag: disposeBag)
            $0.layer.borderColor = UI.layerColor.cgColor
            $0.layer.borderWidth = 1
        }
        scrollView.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.leading.width.equalToSuperview().inset(UI.elmtMargin)
            $0.top.equalToSuperview().inset(UI.elmtMargin)
        }
        
        return titleView
    }
    
    private func buildDescriptionView(text: String, topView: UIView) -> UITextView {
        let descriptionView = UITextView()
        descriptionView.do {
            $0.font = UI.descriptionFont
            $0.text = text
            $0.setAutoHeight(disposeBag: disposeBag)
            $0.layer.borderColor = UI.layerColor.cgColor
            $0.layer.borderWidth = 1
        }
        scrollView.addSubview(descriptionView)
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(UI.elmtMargin)
            $0.leading.width.equalToSuperview().inset(UI.elmtMargin)
        }
        
        return descriptionView
    }
    
    private func buildImageSlider(imageList: [String], btmView: UIView) -> UIScrollView {
        let sliderView = UIScrollView()
        sliderView.do {
            $0.backgroundColor = UI.layerColor
            $0.layer.borderColor = UI.layerColor.cgColor
            $0.layer.borderWidth = 1
        }
        view.addSubview(sliderView)
        sliderView.snp.makeConstraints {
            $0.leading.width.equalToSuperview()
            $0.height.equalTo((imageList.count > 0) ? UI.sliderHeight : 0)
            $0.bottom.equalTo(btmView.snp.top)
        }
        
        for i in 0..<imageList.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.kf.setImage(with: URL(string: imageList[i]), placeholder: UIImage(named: "placeholder"))
            
            sliderView.addSubview(imageView)
            imageView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(UI.elmtMargin)
                $0.leading.equalToSuperview().offset((UI.imgSize + UI.elmtMargin) * CGFloat(i))
                $0.height.width.equalTo(UI.imgSize)
            }
        }
        
        return sliderView
    }
    
    private func buildToolbar() -> UIView {
        let cameraBtn = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: nil)
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let actionSheet = buildActionSheet()
        
        cameraBtn.rx.tap
            .subscribe(onNext: { [weak self] id in
                self?.present(actionSheet, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        let toolbar = buildBtmToolbar(items: [leftSpace, cameraBtn])
        view.addSubview(toolbar)
        toolbar.snp.makeConstraints {
            $0.leading.width.bottom.equalToSuperview()
            $0.height.equalTo(Constants.UI.Base.toolBarHeight)
        }
        
        return toolbar
    }
    
    private func buildActionSheet() -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: PhotoType.take.getPhotoTypeName(), style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: PhotoType.library.getPhotoTypeName(), style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: PhotoType.url.getPhotoTypeName(), style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        return actionSheet
    }
}
