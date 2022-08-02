//
//  BillListPresenter.swift
//  MyBill
//
//  Created by ChangMin on 2022/08/02.
//

import Foundation

protocol BillListProtocol: AnyObject {
    func setupNavigationBar()
    func setupLayout()
}

final class BillListPresenter {
    private weak var viewController: BillListProtocol?
    
    init(viewController: BillListProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupLayout()
    }
}
