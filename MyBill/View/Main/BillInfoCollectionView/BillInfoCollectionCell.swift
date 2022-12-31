//
//  BillInfoCollectionCell.swift
//  MyBill
//
//  Created by ChangMin on 2022/07/31.
//

import UIKit
import SnapKit

final class BillInfoCollectionCell: UICollectionViewCell {
    static let identifier = String(describing: BillInfoCollectionCell.self)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .textColor
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
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
    
    required init?(coder: NSCoder) { fatalError() }
    
    func setupCell(bill: Bill) {
        titleLabel.text = bill.title
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let amountFormat = "금액: %@원"
        amountLabel.text = String(format: amountFormat, (numberFormatter.string(from: bill.amount as NSNumber) ?? ""))
        
        dateLabel.text = bill.date
        memoTextView.text = bill.memo
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        amountLabel.text = "금액: "
        dateLabel.text = ""
        memoTextView.text = ""
    }
}

private extension BillInfoCollectionCell {
    func setupView() {
        layer.cornerRadius = 14
        layer.masksToBounds = true
        
        [titleLabel, dateLabel, amountLabel, memoTextView].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(8)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        amountLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel)
            $0.trailing.greaterThanOrEqualToSuperview().inset(8)
        }
        
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(amountLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(2)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
}
