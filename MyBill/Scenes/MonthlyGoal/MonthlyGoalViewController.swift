//
//  MonthlyGoalViewController.swift
//  MyBill
//
//  Created by ChangMin on 2022/08/02.
//

import SnapKit
import UIKit

final class MonthlyGoalViewController: UIViewController {
    private lazy var presenter = MonthlyGoalPresenter(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension MonthlyGoalViewController: MonthlyGoalProtocol {
    func setupNavigationBar() {
        view.backgroundColor = .systemBackground
    }
    
    func setupLayout() {
        
    }
}

private extension MonthlyGoalViewController {
    
}
