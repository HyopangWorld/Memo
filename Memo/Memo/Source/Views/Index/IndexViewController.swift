//
//  IndexViewController.swift
//  Memo
//
//  Created by 김효원 on 10/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAppState
import RxDataSources
import RxOptional
import Then
import SnapKit

protocol IndexViewBindable {
    var viewWillAppear: PublishRelay<Void> { get }
    var deleteData: PublishRelay<Int> { get }
    var cellData: Driver<[MemoListCell.Data]> { get }
    var reloadList: Signal<Void> { get }
}

final class IndexViewController: ViewController<IndexViewBindable> {
    private typealias TEXT = Constants.Text.Index
    private typealias UI = Constants.UI.Index
    
    let tableView = UITableView()
    
    let deleteCell = PublishRelay<IndexPath>()
    
    override func bind(_ viewModel: IndexViewBindable) {
        self.disposeBag = DisposeBag()
        
        self.rx.viewWillAppear
            .map{ _ in Void() }
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)
        
        deleteCell
            .map { [weak self] indexPath in
                (self?.tableView.cellForRow(at: indexPath) as! MemoListCell).id
            }
            .filterNil()
            .bind(to: viewModel.deleteData)
            .disposed(by: disposeBag)
        
        viewModel.cellData
            .drive(tableView.rx.items(cellIdentifier: String(describing: MemoListCell.self), cellType: MemoListCell.self)) { index, data, cell in
                cell.setData(data: data)
            }
            .disposed(by: disposeBag)
        
        viewModel.reloadList
            .emit(onNext: { [weak self] _ in self?.tableView.reloadData() })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    override func layout() {
        view.backgroundColor = UI.backgroundColor
        navigationItem.title = TEXT.title
        buildMemoList(bottomView: buildToolbar())
    }
}

extension IndexViewController {
    private func buildMemoList(bottomView: UIView) {
        tableView.do {
            $0.register(MemoListCell.self, forCellReuseIdentifier: String(describing: MemoListCell.self))
            $0.backgroundColor = .white
            $0.separatorInset.left = Constants.UI.IndexCell.sideMargin
            $0.separatorInset.right = Constants.UI.IndexCell.sideMargin
            $0.rowHeight = Constants.UI.IndexCell.height
            $0.delegate = self
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(self.getTopAreaHeight())
            $0.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    private func buildToolbar() -> UIView {
        let toolBar = UIToolbar()
        let editBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: nil)
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        editBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let editViewController = EditViewController()
                self?.navigationController?.pushViewController(editViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        toolBar.setItems([leftSpace, editBtn], animated: true)
        toolBar.backgroundColor = UI.backgroundColor
        toolBar.barTintColor = UI.backgroundColor
        view.addSubview(toolBar)
        var bottom: CGFloat = 0
        if #available(iOS 11.0, *) { bottom = Constants.UI.Base.safeAreaInsetsTop }
        toolBar.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(bottom)
            $0.height.equalTo(UI.toolBarHeight)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor(displayP3Red: (223/255), green: (223/255), blue: (223/255), alpha: (223/255))
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalTo(toolBar.snp.top)
        }
        
        return line
    }
}

extension IndexViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "삭제") { [weak self] (action, indexPath) in
            self?.deleteCell.accept(indexPath)
        }
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MemoListCell else { return }
        let detailViewController = DetailViewController()
        let detailViewModel = DetailViewModel()
        detailViewController.id = cell.id
        detailViewController.bind(detailViewModel)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
