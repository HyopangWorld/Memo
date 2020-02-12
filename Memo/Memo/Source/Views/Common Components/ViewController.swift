//
//  ViewController.swift
//  Memo
//
//  Created by 김효원 on 10/02/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import UIKit
import RxSwift

/*
 - `ViewBindable`:
`UIViewController`에 bind, protocol로 작성해야함.
 */

class ViewController<ViewBindable>: UIViewController {
    var disposeBag = DisposeBag()
    let indicator = UIActivityIndicatorView()

    init() {
        super.init(nibName: nil, bundle: nil)

        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
    }

    /*
     `ViewBindable`과 각 컴포넌트들의 속성을 binding
     
     - `bind`에서는 가변적인 속성의 정의 동작과 위치의 변화를 모두 수행할 수 있다
     *(단 직접적으로 입력하는 동작이 아닌 어떠한 Observable에 따라 변화되는 동작만을 정의)*
     
     - Parameters:
     - viewModel: view에 bind 할 수 있는 `ViewBindable`, protocol로 작성해야함.
     */
    func bind(_ viewModel: ViewBindable) {}

    /*
     `UIViewController`의 다양한 레이아웃 속성을 정의
     
     - 컴포넌트들의 속성을 정의하는 동작을 수행
     - 컴포넌트들의 위치를 정의하고 부모View에 Add하는 동작을 수행
     */
    func layout() {}

    /*
     `init()` 시점에 주입되어야 할 Cocoa 종속성 properties에 대한 변경이 필요할 때 사용함.
     주의: init 시점이 아닌 properties를 변경할 경우 viewDidLoad() 시점에 영향을 줄 수 있음
     */
    func initialize() {}

    /*
     [debug] 메모리 해제 확인
     */
    deinit {
        #if DEBUG
        print("\(self) 메모리 해제")
        #endif
    }
}
