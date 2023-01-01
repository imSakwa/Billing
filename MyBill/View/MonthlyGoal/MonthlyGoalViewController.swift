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
        label.text = "닉네임 & 목표액 변경하기"
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .medium)
        textView.isEditable = false
        textView.text =
            """
            본인의 목표액을 수정해봐요.
            이미 등록된 내역들 기준으로 차감된 목표액이 보입니다!
            """
        textView.sizeToFit()
        return textView
    }()
    
    private lazy var nameView: SettingBoxView = {
        let view = SettingBoxView(title: "닉네임", boxType: .text)
        view.inputTextField.delegate = presenter
        view.inputTextField.inputAccessoryView = textfieldAccessoryView
        return view
    }()
    
    private lazy var goalPriceView: SettingBoxView = {
        let view = SettingBoxView(title: "목표액", boxType: .number)
        view.inputTextField.delegate = presenter
        view.inputTextField.inputAccessoryView = textfieldAccessoryView
        return view
    }()
    
//    private lazy var memoView: SettingBoxView = {
//        let view = SettingBoxView(title: "메모(최대 30자)", boxType: .text)
//        view.inputTextField.delegate = presenter
//        return view
//    }()
    
    private lazy var textfieldAccessoryView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        return view
    }()
    
    private lazy var enterButton: CommonButtonView = {
        let button = CommonButtonView()
        button.setTitle("완료", for: .normal)
        button.addTarget(self, action: #selector(tapEnterButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension MonthlyGoalViewController: MonthlyGoalProtocol {
    func setMyGoal() {
        if self.checkInputValue() {
            let goalPrice = Int(goalPriceView.inputTextField.text ?? "0")!
            let numberFormat = NumberFormatter()
            numberFormat.numberStyle = .decimal
            
            let balance = numberFormat.string(from: goalPrice as NSNumber)!
            
            UserDefaults.standard.set(nameView.inputTextField.text, forKey: "name")
            UserDefaults.standard.set(balance, forKey: "amount")
            
            completionHandler?()
            
            navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        navigationItem.rightBarButtonItem = settingButton
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapViewForHideKeyboard))
        view.addGestureRecognizer(tapGesture)
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
    
    func setShouldReturn() {
        view.endEditing(true)
    }
    
    func setDidEndEditing(textField: UITextField) {
        if textField == goalPriceView.inputTextField {
            // FIXME: 버튼 활성화 로직 수정
            enterButton.isEnabled = checkInputValue()
        }
        
        if textField == nameView.inputTextField {
            textField.checkMaxLength(textField: textField, maxLength: 10)
        }
    }
}

private extension MonthlyGoalViewController {
    @objc func keyboardWillShow() {
        view.frame.origin.y = 0
        view.frame.origin.y -= 30
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    @objc func tapEnterButton() {
        presenter.tapEnterButton()
    }
    
    @objc func tapViewForHideKeyboard() {
        view.endEditing(true)
    }
    
    /// 입력 내용 체크 메서드
    func checkInputValue() -> Bool {
        guard let goalPriceValue = goalPriceView.inputTextField.text,
                goalPriceValue == ""
        else { return true }
        
        let alertController = UIAlertController(
            title: nil,
            message: "목표 금액을 입력해주세요.",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(
            title: "확인",
            style: .default)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
        return false
    }
}

