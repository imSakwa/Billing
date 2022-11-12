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
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
}
