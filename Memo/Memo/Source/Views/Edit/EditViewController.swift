//
//  EditViewController.swift
//  Memo
//
//  Created by 김효원 on 11/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit
import MobileCoreServices
import RxSwift
import RxCocoa
import RxAppState
import Then
import SnapKit

protocol EditViewBindable {
    var createData: PublishRelay<Void> { get }
    var saveData: PublishRelay<Memo> { get }
    var newMemo: Signal<Memo> { get }
    var saveMemo: Signal<[Memo]> { get }
}

final class EditViewController: ViewController<EditViewBindable> {
    typealias UI = Constants.UI.Edit
    
    let imagePicker = UIImagePickerController()
    let scrollView = UIScrollView()
    let sliderView = UIScrollView()
    let descriptionView = UITextView()
    let titleView = UITextView()
    
    var memo: Memo?
    
    override func bind(_ viewModel: EditViewBindable) {
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        
        self.rx.viewDidLoad
            .filter { self.memo?.date == nil }
            .bind(to: viewModel.createData)
            .disposed(by: disposeBag)
        
        viewModel.newMemo.asObservable()
            .subscribe(onNext: { [weak self] data in self?.memo = data })
            .disposed(by: disposeBag)
        
        viewModel.saveMemo.asObservable()
            .subscribe(onNext: { [weak self] _ in self?.navigationController?.popToRootViewController(animated: true) })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    override func layout() {
        navigationController?.navigationBar.barTintColor = Constants.UI.Base.backgroundColor
        navigationController?.navigationBar.tintColor = Constants.UI.Base.foregroundColor
        
        view.backgroundColor = Constants.UI.Base.backgroundColor
        self.setTouchEndEditing(disposeBag: disposeBag)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = doneBtn
        doneBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.memo?.title = self?.titleView.text ?? ""
                self?.memo?.description = self?.descriptionView.text ?? ""
                if let memo = self?.memo { self?.viewModel?.saveData.accept(memo) }
            })
            .disposed(by: disposeBag)
        
        buildMemoBoard(data: memo)
    }
}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }

        if let fileName = ImageManagerImpl.shard.saveImage(image: image) {
            self.memo?.imageList?.append(fileName)
            self.reloadImageSlider()
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
