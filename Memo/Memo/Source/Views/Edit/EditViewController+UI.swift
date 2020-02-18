//
//  EditViewController+UI.swift
//  Memo
//
//  Created by 김효원 on 17/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

// MARK: - MemoBoard

extension EditViewController {
    func buildMemoBoard(data: Memo?) {
        buildTitleView(text: data?.title ?? "" )
        buildDescriptionView(text: data?.description ?? "", topView: titleView)
        buildToolbar()
        buildImageSlider(list: data?.imageList ?? [])
        
        scrollView.do {
            $0.setContentOffset(.zero, animated: false)
            $0.backgroundColor = Constants.UI.Base.backgroundColor
            $0.showsVerticalScrollIndicator = false
        }
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(self.getTopAreaHeight())
            $0.bottom.equalTo(sliderView.snp.top)
        }
        
        Observable.combineLatest(titleView.rx.didChange.startWith(Void()), descriptionView.rx.didChange.startWith(Void()))
            .subscribe(onNext: { [weak self] _ in
                let height = (self?.titleView.getEstimatedSize().height ?? 0) + (self?.descriptionView.getEstimatedSize().height ?? 0) + (UI.elmtMargin * 3)
                self?.scrollView.contentSize = CGSize(width: self?.view.frame.width ?? 0, height: height)
            })
            .disposed(by: disposeBag)
    }
    
    private func buildTitleView(text: String) {
        titleView.do {
            $0.font = UI.titleFont
            $0.text = text
            $0.setAutoHeight(disposeBag: disposeBag)
            $0.layer.borderColor = UI.layerColor.cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = Constants.UI.Base.backgroundColor
        }
        scrollView.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.leading.width.equalToSuperview().inset(UI.elmtMargin)
            $0.top.equalToSuperview().inset(UI.elmtMargin)
        }
    }
    
    private func buildDescriptionView(text: String, topView: UIView) {
        descriptionView.do {
            $0.font = UI.descriptionFont
            $0.text = text
            $0.setAutoHeight(disposeBag: disposeBag)
            $0.layer.borderColor = UI.layerColor.cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = Constants.UI.Base.backgroundColor
        }
        scrollView.addSubview(descriptionView)
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(UI.elmtMargin)
            $0.leading.width.equalToSuperview().inset(UI.elmtMargin)
        }
    }
}

// MARK: - ImageSlider

extension EditViewController {
    func reloadImageSlider() {
        for view in self.sliderView.subviews{ view.removeFromSuperview() }
        self.buildImageSlider(list: self.memo?.imageList ?? [])
    }
    
    private func buildImageSlider(list: [String]) {
        sliderView.do {
            $0.backgroundColor = UI.layerColor
            $0.layer.borderColor = UI.layerColor.cgColor
            $0.layer.borderWidth = 1
            $0.showsHorizontalScrollIndicator = false
        }
        view.addSubview(sliderView)
        var bottom = Constants.UI.Base.toolBarHeight
        if #available(iOS 11.0, *) { bottom += Constants.UI.Base.safeAreaInsetsTop >= 44 ? Constants.UI.Base.safeAreaInsetsTop : 0 }
        sliderView.snp.makeConstraints {
            $0.leading.width.equalToSuperview()
            $0.height.equalTo(UI.imgSize)
            $0.bottom.equalToSuperview().inset(bottom)
        }
        
        if list.count <= 0 {
            let notice = UILabel()
            notice.text = "사진을 추가해 보세요."
            notice.textColor = UIColor(displayP3Red: (180/255), green: (180/255), blue: (180/255), alpha: 1)
            sliderView.addSubview(notice)
            notice.snp.makeConstraints {
                $0.centerX.centerY.equalToSuperview()
            }
        }
        
        for i in 0..<list.count {
            buildImage(i: i, value: list[i])
        }
        
        sliderView.contentSize = CGSize(width: UI.imgSize * CGFloat(list.count) + UI.elmtMargin * CGFloat(list.count+1), height: UI.imgSize)
    }
    
    private func buildImage(i: Int, value: String) {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIdentifier = "\(i)"
        if let image = ImageManagerImpl.shard.loadImage(fileName: value) { imageView.image = image }
        else { imageView.kf.setImage(with: URL(string: value), placeholder: UIImage(named: "placeholder")) }
        
        sliderView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().inset(UI.elmtMargin)
            $0.leading.equalToSuperview().offset(UI.imgSize * CGFloat(i) + UI.elmtMargin * CGFloat(i+1))
            $0.height.width.equalTo(UI.imgSize)
        }
        
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            guard let index = Int(imageView.accessibilityIdentifier ?? "") else { return }
            self?.memo?.imageList?.remove(at: index)
            for view in self?.sliderView.subviews ?? [] { view.removeFromSuperview() }
            self?.buildImageSlider(list: self?.memo?.imageList ?? [])
        }))
        
        let deleteBtn = UIButton()
        deleteBtn.setImage(UIImage(named: "delete_button.png"), for: .normal)
        deleteBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        sliderView.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().offset((UI.imgSize + UI.elmtMargin) * CGFloat(i))
            $0.top.equalToSuperview()
            $0.width.height.equalTo(UI.delBtnSize)
        }
    }
}

// MARK: - Toolbar

extension EditViewController {
    private func buildToolbar() {
        let cameraBtn = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: nil)
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let actionSheet = buildActionSheet()
        cameraBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.present(actionSheet, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        _ = buildBtmToolbar(items: [leftSpace, cameraBtn])
    }
    
    private func buildActionSheet() -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: PhotoType.take.getPhotoTypeName(), style: .default, handler: { _ in self.openCamera() }))
        actionSheet.addAction(UIAlertAction(title: PhotoType.library.getPhotoTypeName(), style: .default, handler: { _ in self.openAlbum() }))
        actionSheet.addAction(UIAlertAction(title: PhotoType.url.getPhotoTypeName(), style: .default, handler: { _ in self.openUrl() }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        return actionSheet
    }
    
    private func openCamera() {
        if UIImagePickerController .isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: false, completion: nil)
        }
    }
    
    private func openAlbum() {
        if UIImagePickerController .isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: false, completion: nil)
        }
    }
    
    private func openUrl() {
        let prompt = UIAlertController(title: "다운받을 URL 입력해주세요", message: nil, preferredStyle: .alert)
        prompt.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input URL for download image file..."
        })
        prompt.addAction(UIAlertAction(title: "다운로드", style: .default, handler: { _ in
            if let url = prompt.textFields?.first?.text {
                self.memo?.imageList?.append(url)
                self.reloadImageSlider()
            }
        }))
        prompt.addAction(UIAlertAction(title: "붙여넣기", style: .default, handler: { _ in
            guard let textfield = prompt.textFields?.first else { return }
            textfield.text = UIPasteboard.general.string ?? ""
            self.present(prompt, animated: true, completion: nil)
        }))
        prompt.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(prompt, animated: true, completion: nil)
    }
}
