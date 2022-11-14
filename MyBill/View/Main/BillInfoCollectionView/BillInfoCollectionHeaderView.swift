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
    func tapAddButton()
}

final class BillInfoCollectionHeaderView: UICollectionReusableView {
    static let identifier = "BillInfoHeaderView"
    var delegate: BillInfoHeaderDelegate?
    
    private lazy var goalButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(tapSettingButton), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = UserDefaults.standard.value(forKey: "name") as? String ?? "닉네임"
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textColor = .textColor
        return label
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "목표액 : " + (UserDefaults.standard.value(forKey: "balance") as? String ?? "0") + "원"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .textColor
        return label
    }()
    
    private lazy var conditionLabel: UILabel = {
        let label = UILabel()
        label.text = "파이팅🔥"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .textColor
        return label
    }()
   
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(tapAddButton), for: .touchUpInside)
        button.tintColor = .black
        return button
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
        [nameLabel, balanceLabel, conditionLabel, goalButton, addButton].forEach { self.addSubview($0) }
        
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
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(goalButton)
            $0.trailing.equalTo(goalButton.snp.leading).offset(-12)
            $0.size.equalTo(24)
        }
    }
    
    @objc func tapSettingButton(_ sender: UIButton) {
        delegate?.tapSettingButton()
    }
    
    @objc func tapAddButton(_ sender: UIButton) {
//        APIService.setBill(bill: Bill(title: "입력 제목", cost: 119119, memo: "입력 메모", date: "2022-10-02 15:00"))
        
        delegate?.tapAddButton()
    }
}
