//
//  AddBillViewController.swift
//  MyBill
//
//  Created by ChangMin on 2022/10/03.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

protocol AddBillDelegate {
    func updateBillList()
}

final class AddBillViewController: UIViewController {
    private var viewModel: AddBillViewModel
    private let disposeBag = DisposeBag()
    var completionHandler: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "사용한 금액을 입력해주세요."
        return label
    }()
    
    private lazy var titleInputBox: SettingBoxView = {
        let box = SettingBoxView(title: "제목", boxType: .text)
        return box
    }()
    
    private lazy var dateInputBox: SettingBoxView = {
        let box = SettingBoxView(title: "날짜", boxType: .date)
        return box
    }()
    
    private lazy var amountInputBox: SettingBoxView = {
        let box = SettingBoxView(title: "금액", boxType: .number)
        return box
    }()
    
    private lazy var memoInputBox: SettingBoxView = {
        let box = SettingBoxView(title: "메모", boxType: .multilineText)
        box.inputTextField.inputAccessoryView = enterButton
        return box
    }()
    
    private lazy var enterButton: CommonButtonView = {
        let button = CommonButtonView()
        button.setTitle("완료", for: .normal)
        return button
    }()
    
    init(viewModel: AddBillViewModel = AddBillViewModel()) {
        self.viewModel = viewModel
        self.viewModel.uuid = UIDevice.current.identifierForVendor!.uuidString
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        addTapGesture()
        addKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        removeKeyboardNotification()
    }
}

extension AddBillViewController: UITextFieldDelegate {
}

private extension AddBillViewController {
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    @objc func keyboardWillShow(_ sender: Notification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y = 0
            view.frame.origin.y -= keyboardSize.size.height
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        view.frame.origin.y = 0
    }
    
    func setupView() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        [titleLabel, titleInputBox, dateInputBox, amountInputBox, memoInputBox, enterButton]
            .forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        titleInputBox.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        dateInputBox.snp.makeConstraints {
            $0.top.equalTo(titleInputBox.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(titleInputBox)
        }
        
        amountInputBox.snp.makeConstraints {
            $0.top.equalTo(dateInputBox.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(titleInputBox)
        }
        
        memoInputBox.snp.makeConstraints {
            $0.top.equalTo(amountInputBox.snp.bottom).offset(20)
            $0.height.equalTo(100)
            $0.leading.trailing.equalTo(titleInputBox)
        }
        
        enterButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleInputBox)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(48)
        }
    }
    
    func bindViewModel() {
        let input = AddBillViewModel.Input(
            titleText: titleInputBox.inputTextField.rx.text.orEmpty.asObservable(),
            dateText: dateInputBox.datePickerView.rx.date.asObservable(),
            amountText: amountInputBox.inputTextField.rx.text.orEmpty.asObservable(),
            memoText: memoInputBox.inputTextField.rx.text.orEmpty.asObservable(),
            enterButton: enterButton.rx.tap.asObservable()
        )
                
        let output = viewModel.transform(input: input)
        
        output.isEnterEnabled
            .drive(
                onNext: { [weak self] in
                    self?.enterButton.isEnabled = $0
                }
            )
            .disposed(by: disposeBag)
        
        output.addBill
            .subscribe(
                onNext: { [weak self] in
                    self?.completionHandler?()
                    self?.dismiss(animated: true)
                }
            )
            .disposed(by: disposeBag)
    }
    
    
}
