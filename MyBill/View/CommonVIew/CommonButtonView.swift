//
//  CommonButtonView.swift
//  MyBill
//
//  Created by ChangMin on 2022/11/12.
//

import UIKit

final class CommonButtonView: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(.black, for: .normal)
        setTitleColor(.systemGray, for: .disabled)
        backgroundColor = .secondarySystemBackground
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
