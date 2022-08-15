//
//  BillInfoCollectionCell.swift
//  MyBill
//
//  Created by ChangMin on 2022/07/31.
//

import UIKit
import SnapKit

final class BillInfoCollectionCell: UICollectionViewCell {
    static let identifier = "BillInfoCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .textColor
        return label
    }()
    
    private lazy var costLabel: UILabel = {
        let label = UILabel()
        label.text = "금액: "
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .textColor
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .textColor
        return label
    }()
    
    private lazy var memoTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.textColor = .textColor
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(bill: Bill) {
        titleLabel.text = bill.title
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        costLabel.text = (costLabel.text ?? "")+(numberFormatter.string(from: bill.cost as NSNumber) ?? "")
        
        dateLabel.text = bill.date
        memoTextView.text = bill.memo
    }
}

private extension BillInfoCollectionCell {
    func setupView() {
        self.layer.cornerRadius = 14
        self.layer.masksToBounds = true
        
        [titleLabel, dateLabel, costLabel, memoTextView].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(8)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        costLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel)
        }
        
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(costLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(2)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
}
