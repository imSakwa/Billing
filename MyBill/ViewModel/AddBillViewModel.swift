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
    private let disposeBag = DisposeBag()
    private let titleText = BehaviorRelay(value: "")
    private let dateText = BehaviorRelay(value: "")
    private let amountText = BehaviorRelay(value: "0")
    private let memoText = BehaviorRelay(value: "")
    private let enterButtonTap = PublishRelay<Void>()
    var uuid: String = ""
    
    struct Input {
        let titleText: Observable<String>
        let dateText: Observable<Date>
        let amountText: Observable<String>
        let memoText: Observable<String>
        let enterButton: Observable<Void>
    }
    
    struct Output {
        let isEnterEnabled: Driver<Bool>
        let addBill: Observable<Void>
    }
    
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
        
        input.amountText
            .subscribe(
                onNext: { [weak self] in
                    self?.amountText.accept($0)
                }
            )
            .disposed(by: disposeBag)
        
        input.memoText
            .subscribe(
                onNext: { [weak self] in
                    self?.memoText.accept($0)
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
            amountText.asDriver(),
            memoText.asDriver()
        ) {
            !$0.isEmpty && !$1.isEmpty && !$2.isEmpty
        }
        
        return Output(
            isEnterEnabled: validateEnterButton,
            addBill: enterButtonTap.asObservable()
        )
    }
    
    private func clickEnterButton() {
        let titleValue = titleText.value
        let dateValue = dateText.value
        let amountValue = amountText.value
        let memoValue = memoText.value
        
        let bill = Bill(
            title: titleValue,
            amount: Int(amountValue)!,
            memo: memoValue,
            date: dateValue
        )
        
        APIService.setBill(bill: bill, uuid: uuid) { error in
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
