//
//  Bill.swift
//  MyBill
//
//  Created by ChangMin on 2022/07/31.
//

import Foundation

import RealmSwift

struct Bill: Codable, Hashable {
//    let id = UUID()
    let title: String
    let amount: Int
    let memo: String
    let date: String
}

struct BillList: Codable, Hashable {
    let billList: [Bill]
    
    enum CodingKeys: String, CodingKey {
        case billList = "bill"
    }
}

class BillObject: Object {
    @Persisted var title: String
    @Persisted var amount: Int
    @Persisted var memo: String
    @Persisted var date: String
    
    convenience init(title: String, amount: Int, memo: String, date: String) {
        self.init()
        
        self.title = title
        self.amount = amount
        self.memo = memo
        self.date = date
    }
}

struct Info: Hashable {
    let name: String
    let amount: String
}
