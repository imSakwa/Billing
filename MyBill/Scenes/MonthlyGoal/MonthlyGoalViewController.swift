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
    
    private lazy var settingButton: UIBarButtonItem = {
        let image = UIImage(named: "gearshape")
        let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
        return barButton
    }()
    
    private lazy var nameView: SettingBoxView = {
        let view = SettingBoxView(title: "닉네임", boxType: .text)
        view.inputTextField.delegate = self
        return view
    }()
    
    private lazy var goalPriceView: SettingBoxView = {
        let view = SettingBoxView(title: "목표액", boxType: .number)
        view.inputTextField.delegate = self
        return view
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
    func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationItem.rightBarButtonItem = settingButton
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupLayout() {
        [nameView, goalPriceView].forEach { view.addSubview($0) }
        
        nameView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        goalPriceView.snp.makeConstraints {
            $0.top.equalTo(nameView.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(nameView)
        }
    }
}

private extension MonthlyGoalViewController {
    @objc func keyboardWillShow() {
        self.view.frame.origin.y -= 150
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
}

extension MonthlyGoalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == goalPriceView.inputTextField {
            guard let value = textField.text, Int(value) == 0 else { return }
            
            // TODO: 0인 경우에 alert 창 띄우기
            print("0")
            
        }
    }
}
