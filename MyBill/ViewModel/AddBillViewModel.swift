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
        let titleText: Observable<String>
        let dateText: Observable<Date>
        let costText: Observable<String>
        let enterButton: Observable<Void>
    }
    
    struct Output {
        let isEnterEnabled: Driver<Bool>
        let addBill: Observable<Void>
    }
    
    private let disposeBag = DisposeBag()
    private let titleText = BehaviorRelay(value: "")
    private let dateText = BehaviorRelay(value: "")
    private let costText = BehaviorRelay(value: "0")
    private let enterButtonTap = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        input.titleText
            .subscribe(onNext: { [weak self] in
                self?.titleText.accept($0)
            })
            .disposed(by: disposeBag)
        
        
        input.dateText
            .subscribe(
                onNext: { [weak self] in
                    self?.dateText.accept((self?.dateToString(date: $0))!)
                }
            )
            .disposed(by: disposeBag)
        
        input.costText
            .subscribe(
                onNext: { [weak self] in
                    self?.costText.accept($0)
                }
            )
            .disposed(by: disposeBag)
        
        input.enterButton
            .subscribe(
                onNext: { [weak self] in
                    self?.clickEnterButton()
                    self?.enterButtonTap.accept($0)
                }
            )
            .disposed(by: disposeBag)
        
        let validateEnterButton = Driver.combineLatest(
            titleText.asDriver(),
            dateText.asDriver()
        ) {
            !$0.isEmpty && !$1.isEmpty
        }
        
        return Output(
            isEnterEnabled: validateEnterButton,
            addBill: enterButtonTap.asObservable()
        )
    }
    
    private func clickEnterButton() {
        let titleValue = titleText.value
        let dateValue = dateText.value
        let costValue = costText.value
        
        let bill = Bill(title: titleValue, cost: Int(costValue)!, memo: "", date: dateValue)
        
        APIService.setBill(bill: bill) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    private func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }
}
