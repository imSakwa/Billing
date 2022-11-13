//
//  StartingViewModel.swift
//  MyBill
//
//  Created by ChangMin on 2022/11/12.
//

import Foundation

import RxCocoa
import RxSwift

protocol StartingViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}


final class StartingViewModel: StartingViewModelType {
    struct Input {
        let nameText: Observable<String>
        let targetAmountText: Observable<String>
        let startButton: Observable<Void>
    }
    
    struct Output {
        let start: Observable<Void>
    }
    
    private let disposeBag = DisposeBag()
    private let startButtonTap = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        input.startButton
            .subscribe(onNext: { [weak self] in
                self?.startButtonTap.accept($0)
            })
            .disposed(by: disposeBag)
        
        return Output(start: startButtonTap.asObservable())
    }
    
}
