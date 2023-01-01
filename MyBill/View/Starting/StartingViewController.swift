//
//  StartingViewController.swift
//  MyBill
//
//  Created by ChangMin on 2022/11/12.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class StartingViewController: UIViewController {
    let viewModel: StartingViewModel
    let disposeBag = DisposeBag()
    
    private lazy var welcomTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.text = "반갑습니다!👋"
        return label
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.text = """
                     닉네임과 절약 목표액을 입력하신 후
                     시작버튼을 눌러주세요.
                     등록 후 언제든지 설정에서 변경 가능합니다.
                     """
        return label
    }()
    
    private lazy var nameTextField: SettingBoxView = {
        let box = SettingBoxView(title: "닉네임", boxType: .text)
        return box
    }()
    
    private lazy var targetAmountTextField: SettingBoxView = {
        let box = SettingBoxView(title: "목표액", boxType: .number)
        box.inputTextField.delegate = self
        return box
    }()
    
    private lazy var startButton: CommonButtonView = {
        let button = CommonButtonView()
        button.setTitle("시작하기", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    init(viewModel: StartingViewModel = StartingViewModel()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindViewModel()
    }
}

private extension StartingViewController {
    func setupView() {
        view.backgroundColor = .white
        
        [welcomTitleLabel, welcomeLabel, nameTextField, targetAmountTextField, startButton].forEach { view.addSubview($0) }
        
        welcomTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide)
                .offset(20)
        }
        
        setAttributeToLabel()
        
        welcomeLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(welcomTitleLabel.snp.bottom)
                .offset(8)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        targetAmountTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        startButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.width.equalTo(UIScreen.main.bounds.width / 2)
            $0.height.equalTo(48)
        }
    }
    
    func bindViewModel() {
        let input = StartingViewModel.Input(
            nameText: nameTextField.inputTextField.rx.text.orEmpty.asObservable(),
            targetAmountText: targetAmountTextField.inputTextField.rx.text.orEmpty.asObservable(),
            startButton: startButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.buttonEnabled
            .drive(onNext: { [weak self] in
                self?.startButton.isEnabled = $0
            })
            .disposed(by: disposeBag)
        
        output.start
            .subscribe(onNext: { [weak self] in
                let billListVC = BillListViewController()
                self?.navigationController?.pushViewController(billListVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func setAttributeToLabel() {
        let fontSize: UIFont = .systemFont(ofSize: 17)
        let attributeStr = NSMutableAttributedString(string: welcomeLabel.text!)
        attributeStr.addAttribute(
            .font,
            value: fontSize,
            range: (welcomeLabel.text! as NSString).range(of: "등록 후 언제든지 설정에서 변경 가능합니다.")
        )

        welcomeLabel.attributedText = attributeStr
    }
}

extension StartingViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        let format = NumberFormatter()
        format.numberStyle = .decimal
        format.locale = .current
        format.maximumFractionDigits = 0
        
        if textField.text?.first == "0" && textField.text == "" {
            return false
            
        } else {
            
            if let removeAllSeperator = textField.text?.replacingOccurrences(of: ",", with: "") {
                
                let beforeFormattedString = removeAllSeperator + string
                
                if format.number(from: string) != nil {
                    // 입력 시
                    let targetAmountInt = Int(beforeFormattedString)!
                    textField.text = format.string(from: targetAmountInt as NSNumber) ?? "0"
                    
                    return false
                    
                } else {
                    // 삭제 시
                    let targetAmountInt = Int(String(beforeFormattedString.dropLast()))!
                    textField.text = format.string(from: targetAmountInt as NSNumber) ?? "0"
                    
                    return false
                }
            }
            return true
        }
    }
}
