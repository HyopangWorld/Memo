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
import Photos
import AVKit

// MARK: - MemoBoard

extension EditViewController {
    func buildMemoBoard(data: Memo?) {
        buildTitleView(text: data?.title ?? "" )
        buildDescriptionView(text: data?.description ?? "")
        buildImageSlider(list: data?.imageList ?? [], btmView: buildToolbar())
        buildScrollView()
    }
    
    private func buildScrollView() {
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
                var height = (self?.titleView.getEstimatedSize().height ?? 0)
                height += (self?.descriptionView.getEstimatedSize().height ?? 0)
                height += (UI.elmtMargin * 3)
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
    
    private func buildDescriptionView(text: String) {
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
            $0.top.equalTo(titleView.snp.bottom).offset(UI.elmtMargin)
            $0.leading.width.equalToSuperview().inset(UI.elmtMargin)
        }
    }
}

// MARK: - ImageSlider

extension EditViewController {
    private func buildImageSlider(list: [String], btmView: UIView) {
        sliderView.do {
            $0.backgroundColor = UI.layerColor
            $0.layer.borderColor = UI.layerColor.cgColor
            $0.layer.borderWidth = 1
            $0.showsHorizontalScrollIndicator = false
        }
        view.addSubview(sliderView)
        sliderView.snp.makeConstraints {
            $0.leading.width.equalToSuperview()
            $0.height.equalTo(UI.imgSize)
            $0.bottom.equalTo(btmView.snp.top)
        }
        
        buildImages(list: list)
    }
    
    func buildImages(list: [String]) {
        for view in self.sliderView.subviews{
            view.removeFromSuperview()
        }
        
        if list.count <= 0 { buildSliderNotice() }
        
        for i in 0..<list.count {
            let imageView = buildImage(i: i, value: list[i])
            buildDelButton(imageView: imageView, index: i)
        }
        
        sliderView.contentSize = CGSize(width: UI.imgSize * CGFloat(list.count) + UI.elmtMargin * CGFloat(list.count+1), height: UI.imgSize)
    }
    
    private func buildSliderNotice() {
        let notice = UILabel()
        notice.do {
            $0.text = TEXT.notice
            $0.textColor = UI.noticeColor
        }
        sliderView.addSubview(notice)
        notice.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func buildImage(i: Int, value: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.do {
            $0.contentMode = .scaleAspectFit
            $0.accessibilityIdentifier = "\(i)"
            if let image = ImageManagerImpl.shard.loadImage(fileName: value) { $0.image = image }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    imageView.kf.setImage(with: URL(string: value), placeholder: UIImage(named: "placeholder"))
                }
            }
        }
        sliderView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().inset(UI.elmtMargin)
            $0.leading.equalToSuperview().offset(UI.imgSize * CGFloat(i) + UI.elmtMargin * CGFloat(i+1))
            $0.height.width.equalTo(UI.imgSize)
        }
        
        return imageView
    }
    
    private func buildDelButton(imageView: UIImageView, index i: Int) {
        let deleteBtn = UIButton()
        deleteBtn.setImage(UIImage(named: "delete_button.png"), for: .normal)
        sliderView.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().offset((UI.imgSize + UI.elmtMargin) * CGFloat(i))
            $0.top.equalToSuperview()
            $0.width.height.equalTo(UI.delBtnSize)
        }
        
        deleteBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let index = Int(imageView.accessibilityIdentifier ?? "") else { return }
                self?.memo?.imageList?.remove(at: index)
                
                self?.buildImages(list: self?.memo?.imageList ?? [])
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Toolbar

extension EditViewController {
    private func buildToolbar() -> UIToolbar {
        let cameraBtn = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: nil)
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let actionSheet = buildActionSheet()
        
        cameraBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.present(actionSheet, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        return buildBtmToolbar(items: [leftSpace, cameraBtn])
    }
    
    private func buildActionSheet() -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: PhotoType.take.getPhotoTypeName(), style: .default,handler: { [weak self] _ in
            self?.openCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: PhotoType.library.getPhotoTypeName(), style: .default, handler: { [weak self] _ in
            self?.openAlbum()
        }))
        actionSheet.addAction(UIAlertAction(title: PhotoType.url.getPhotoTypeName(), style: .default, handler: { [weak self] _ in
            self?.openUrl()
        }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        return actionSheet
    }
    
    private func openCamera() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            if UIImagePickerController .isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: false, completion: nil)
            }
        } else { requestCameraAuth() }
    }
    
    private func requestCameraAuth() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] response in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                if response { self?.openCamera() }
                else { self?.showNotice(noti: "카메라를 사용할 수 없습니다.\n[설정] 에서 허용할 수 있습니다.") }
            }
        }
    }
    
    private func openAlbum() {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            if UIImagePickerController .isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: false, completion: nil)
            }
        } else { requestAlbumAuth() }
    }
    
    private func requestAlbumAuth() {
        PHPhotoLibrary.requestAuthorization({ [weak self] status in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                if status == .authorized { self?.openAlbum() }
                else { self?.showNotice(noti: "앨범을 사용할 수 없습니다.\n[설정] 에서 허용할 수 있습니다.") }
            }
        })
    }
    
    private func openUrl() {
        let prompt = UIAlertController(title: "다운받을 URL 입력해주세요", message: nil, preferredStyle: .alert)
        prompt.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input URL for download image file..."
        })
        prompt.addAction(UIAlertAction(title: "다운로드", style: .default, handler: { [weak self] _ in
            if let url = prompt.textFields?.first?.text {
                self?.memo?.imageList?.append(url)
                self?.buildImages(list: self?.memo?.imageList ?? [])
            }
        }))
        prompt.addAction(UIAlertAction(title: "붙여넣기", style: .default, handler: { [weak self] _ in
            guard let textfield = prompt.textFields?.first else { return }
            textfield.text = UIPasteboard.general.string ?? ""
            
            self?.present(prompt, animated: true, completion: nil)
        }))
        prompt.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(prompt, animated: true, completion: nil)
    }
}
