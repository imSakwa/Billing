//
//  AddBillViewModel.swift
//  MyBill
//
//  Created by ChangMin on 2022/10/03.
//

import Foundation

import RxCocoa
import RxSwift

protocol AddBillViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

final class AddBillViewModel: AddBillViewModelType {
    struct Input {
        let titleText: Observable<Void>
        let dateText: Observable<Void>
    }
    
    struct Output {
        let isEnterEnabled: Driver<Bool>
    }
    
    private let titleText = BehaviorSubject(value: "")
    private let dateText = BehaviorSubject(value: "")
    
    
    func transform(input: Input) -> Output {
        Observable
            .combineLatest(titleText, dateText)
        
        return Output(isEnterEnabled: isEnable)
    }
        
    
}
