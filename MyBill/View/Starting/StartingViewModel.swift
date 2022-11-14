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
        let buttonEnabled: Driver<Bool>
        let start: Observable<Void>
    }
    
    private let disposeBag = DisposeBag()
    private let startButtonTap = PublishRelay<Void>()
    private let nameText = BehaviorRelay(value: "")
    private let targetAmountText = BehaviorRelay(value: "")
    
    func transform(input: Input) -> Output {
        input.nameText
            .subscribe(onNext: { [weak self] in
                self?.nameText.accept($0)
            })
            .disposed(by: disposeBag)
        
        input.targetAmountText
            .subscribe(onNext: { [weak self] in
                self?.targetAmountText.accept($0)
            })
            .disposed(by: disposeBag)
        
        let validationButton = Driver.combineLatest(
            nameText.asDriver(),
            targetAmountText.asDriver()
        ) {
            !$0.isEmpty && !$1.isEmpty
        }
        
        input.startButton
            .subscribe(onNext: { [weak self] in
                self?.startButtonTap.accept($0)
                self?.saveInputData()
            })
            .disposed(by: disposeBag)
        
        return Output(
            buttonEnabled: validationButton,
            start: startButtonTap.asObservable()
        )
    }
    
    func saveInputData() {
        let name = nameText.value
        var targetAmount = targetAmountText.value
        
        let targetAmountInt = Int(targetAmount)!
        let format = NumberFormatter()
        format.numberStyle = .decimal
        
        targetAmount = format.string(from: targetAmountInt as NSNumber)!
        
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(targetAmount, forKey: "amount")
    }
    
}
