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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "사용한 금액을 입력해봐요."
        return label
    }()
    
    private lazy var titleInputBox: SettingBoxView = {
        let box = SettingBoxView(title: "제목", boxType: .text)
        return box
    }()
    
    private lazy var dateInputBox: SettingBoxView = {
        let box = SettingBoxView(title: "날짜", boxType: .text)
        return box
    }()
    
    private lazy var costInputBox: SettingBoxView = {
        let box = SettingBoxView(title: "금액", boxType: .text)
        return box
    }()
    
//    private let memoInputBox: SettingBoxView = {
//        let box = SettingBoxView(title: "제목", boxType: .text)
//        box.text = "메모"
//        return box
//    }()
    
    init(viewModel: AddBillViewModelType = AddBillViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

private extension AddBillViewController {
    func setupView() {
        self.view.backgroundColor = .white
        
        [titleLabel, titleInputBox, dateInputBox, costInputBox ]
            .forEach {
                self.view.addSubview($0)
            }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(36)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        titleInputBox.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        dateInputBox.snp.makeConstraints {
            $0.top.equalTo(titleInputBox.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(titleInputBox)
        }
        
        costInputBox.snp.makeConstraints {
            $0.top.equalTo(dateInputBox.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(titleInputBox)
        }
    }
}
