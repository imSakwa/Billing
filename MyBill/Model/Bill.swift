//
//  Bill.swift
//  MyBill
//
//  Created by ChangMin on 2022/07/31.
//

import Foundation

struct Bill: Decodable {
    let id = UUID()
    let title: String
    let cost: Int
    let memo: String
    let date: String
}
