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
    var completionHandler: (() -> Void)?
    
    private lazy var settingButton: UIBarButtonItem = {
        let image = UIImage(named: "gearshape")
        let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
        return barButton
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "나만의 목표 금액 설정"
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .medium)
        textView.isEditable = false
        textView.text =
            """
            매달 자신의 목표 금액을 입력 해봐요!
            간단한 메모를 통해서 스스로에게 응원도 해봐요!
            
            닉네임은 매번 수정 가능하지만
            목표액은 매월 1일에 가능합니다👍
            """
        textView.sizeToFit()
        return textView
    }()
    
    private lazy var nameView: SettingBoxView = {
        let view = SettingBoxView(title: "닉네임", boxType: .text)
        view.inputTextField.delegate = self
        view.inputTextField.inputAccessoryView = textfieldAccessoryView
        return view
    }()
    
    private lazy var goalPriceView: SettingBoxView = {
        let view = SettingBoxView(title: "목표액", boxType: .number)
        view.inputTextField.delegate = self
        view.inputTextField.inputAccessoryView = textfieldAccessoryView
        return view
    }()
    
    private lazy var memoView: SettingBoxView = {
        let view = SettingBoxView(title: "메모(최대 30자)", boxType: .text)
        view.inputTextField.delegate = self
        return view
    }()
    
    private lazy var textfieldAccessoryView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        return view
    }()
    
    private lazy var enterButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(tapEnterButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension MonthlyGoalViewController: MonthlyGoalProtocol {
    func setMyGoal() {
        self.checkInputValue()
        
        UserDefaults.standard.set(nameView.inputTextField.text, forKey: "name")
        UserDefaults.standard.set(goalPriceView.inputTextField.text, forKey: "balance")
        
        completionHandler?()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationItem.rightBarButtonItem = settingButton
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapViewForHideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func setupLayout() {
        [titleLabel, descriptionTextView,nameView, goalPriceView].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(36)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(120)
        }
        
        nameView.snp.makeConstraints {
            $0.top.equalTo(descriptionTextView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        goalPriceView.snp.makeConstraints {
            $0.top.equalTo(nameView.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        textfieldAccessoryView.addSubview(enterButton)
        
        enterButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(42)
        }
    }
}

private extension MonthlyGoalViewController {
    @objc func keyboardWillShow() {
        self.view.frame.origin.y -= 30
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc func tapEnterButton() {
        presenter.tapEnterButton()
    }
    
    @objc func tapViewForHideKeyboard() {
        self.view.endEditing(true)
    }
    
    /// 입력 내용 체크 메서드
    func checkInputValue() {
        guard let goalPriceValue =  goalPriceView.inputTextField.text, Int(goalPriceValue) == 0 else { return }
        
        let alertController = UIAlertController(
            title: nil,
            message: "목표 금액을 입력해주세요.",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(
            title: "확인",
            style: .default)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true)
    }
}

extension MonthlyGoalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == goalPriceView.inputTextField {
            
            checkInputValue()
        }
        
        if textField == nameView.inputTextField {
            textField.checkMaxLength(textField: textField, maxLength: 10)
        }
    }
}
