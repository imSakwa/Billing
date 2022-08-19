//
//  SettingBoxView.swift
//  MyBill
//
//  Created by ChangMin on 2022/08/15.
//

import SnapKit
import UIKit

enum BoxType {
    case textInput
}

final class SettingBoxView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디"
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "설명"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SettingBoxView {
    func setupView() {
        [titleLabel, detailLabel].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(8)
            $0.height.equalTo(18)
        }
        
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(4)
            $0.leading.equalToSuperview().inset(8)
            $0.height.equalTo(18)
        }
    }
}
