//
//  BillInfoCollectionHeaderView.swift
//  MyBill
//
//  Created by ChangMin on 2022/08/14.
//

import SnapKit
import UIKit

protocol BillInfoHeaderDelegate {
    func tapSettingButton()
}

final class BillInfoCollectionHeaderView: UICollectionReusableView {
    static let identifier = "BillInfoHeaderView"
    var delegate: BillInfoHeaderDelegate?
    
    private lazy var goalButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_goal")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(tapSettingButton), for: .touchUpInside)
        button.tintColor = .buttonColor
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "김김김김"
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textColor = .textColor
        return label
    }()
    
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "?? : 000,000?"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .textColor
        return label
    }()
    
    // TODO: 잔액을 범위로 나눠서 condtionLabel 넣어주기
    private lazy var conditionLabel: UILabel = {
        let label = UILabel()
        label.text = "파이팅🔥"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .textColor
        return label
    }()
   
    override init(frame: CGRect) {
      super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BillInfoCollectionHeaderView {
    func setupLayout() {
        [nameLabel, balanceLabel, conditionLabel, goalButton].forEach { self.addSubview($0) }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(40)
            $0.leading.equalToSuperview().inset(16)
        }
        
        balanceLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        
        conditionLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.top.equalTo(balanceLabel.snp.bottom).offset(8)
        }
        
        goalButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
    }
    
    @objc func tapSettingButton(_ sender: UIButton) {
        delegate?.tapSettingButton()
    }
}
