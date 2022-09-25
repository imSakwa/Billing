//
//  MonthlyGoalPresenter.swift
//  MyBill
//
//  Created by ChangMin on 2022/08/02.
//

import Foundation
import UIKit

protocol MonthlyGoalProtocol: AnyObject {
    func setupNavigationBar()
    func setupObserver()
    func setupLayout()
    func setMyGoal()
    func setShouldReturn()
    func setDidEndEditing(textField: UITextField)
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

extension MonthlyGoalPresenter: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewController?.setShouldReturn()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        viewController?.setDidEndEditing(textField: textField)
    }
}
