//
//  MonthlyGoalPresenter.swift
//  MyBill
//
//  Created by ChangMin on 2022/08/02.
//

import Foundation

protocol MonthlyGoalProtocol: AnyObject {
    func setupNavigationBar()
    func setupObserver()
    func setupLayout()
    func setMyGoal()
}

final class MonthlyGoalPresenter: NSObject {
    private weak var viewController: MonthlyGoalProtocol?
    
    init(viewController: MonthlyGoalProtocol) {
        self.viewController = viewController
        
    }
    
    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupObserver()
        viewController?.setupLayout()
    }
    
    func tapEnterButton() {
        viewController?.setMyGoal()
    }
}
