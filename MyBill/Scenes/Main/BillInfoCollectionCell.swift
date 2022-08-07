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
        return label
    }()
    
    private lazy var costLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var memoTextView: UITextView = {
        let textView = UITextView()
        
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
    }
}

private extension BillInfoCollectionCell {
    func setupView() {
        [titleLabel, dateLabel, costLabel, memoTextView].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(8)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(8)
            
            
        }
    }
}
