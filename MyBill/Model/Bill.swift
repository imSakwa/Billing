//
//  Bill.swift
//  MyBill
//
//  Created by ChangMin on 2022/07/31.
//

import Foundation

struct Bill: Codable, Hashable {
//    let id = UUID()
    let title: String
    let cost: Int
    let memo: String
    let date: String
}

struct BillList: Codable {
    let billList: [Bill]
    
    enum CodingKeys: String, CodingKey {
        case billList = "bill"
    }
}
