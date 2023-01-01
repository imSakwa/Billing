//
//  SettingBoxView.swift
//  MyBill
//
//  Created by ChangMin on 2022/08/15.
//

import SnapKit
import UIKit

enum BoxType {
    case text
    case number
    case date
}

final class SettingBoxView: UIView {
    private var boxType: BoxType = .text
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "닉네임"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private(set) lazy var inputTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private(set) lazy var datePickerView: UIDatePicker = {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.isHidden = true
        datePicker.datePickerMode = .dateAndTime
        return datePicker
    }()
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = 70
        return size
    }
    
    init(title: String, boxType: BoxType) {
        super.init(frame: .zero)
        
        backgroundColor = .secondarySystemBackground
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
        
        titleLabel.text = title
        self.boxType = boxType
        
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

private extension SettingBoxView {
    func setupView() {
        switch boxType {
        case .text:
            inputTextField.keyboardType = .default
            
        case .number:
            inputTextField.keyboardType = .numberPad
            inputTextField.addDoneButtonOnKeyboard()
            
        case .date:
            inputTextField.isHidden = true
            datePickerView.isHidden = false
        }
        
        [titleLabel, inputTextField, datePickerView].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(18)
        }
        
        inputTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        datePickerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
}
