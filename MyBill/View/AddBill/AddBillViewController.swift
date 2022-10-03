//
//  AddBillViewController.swift
//  MyBill
//
//  Created by ChangMin on 2022/10/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AddBillViewController: UIViewController {
    var viewModel: AddBillViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: AddBillViewModelType = AddBillViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
