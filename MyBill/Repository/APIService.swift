//
//  APIService.swift
//  MyBill
//
//  Created by ChangMin on 2022/09/25.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

enum APIError: Error {
    case failToGetList
    case failToUnwrapping
    case failToDecoding
    case failToSetList
}


final class APIService {
    
    static func getBillList(uuid: String, completion: @escaping (Result<[Bill], Error>) -> Void) {
        var billArr: [Bill] = []
        let documentListener = Firestore.firestore().collection("BillList").document("\(uuid)")
        
        documentListener.getDocument { (snapshot, error) in
            if error != nil {
                completion(.failure(APIError.failToGetList))
            }
            guard let snapshot = snapshot else {
                return completion(.failure(APIError.failToUnwrapping))
            }
            
            do {
                guard let bill = snapshot.data()?["bill"] as? [[String:Any]] else {
                    return completion(.failure(APIError.failToUnwrapping))
                }
                
                for billList in bill {
                    let billData = try JSONSerialization.data(withJSONObject: billList)
                    let bill = try JSONDecoder().decode(Bill.self, from: billData)
                    billArr.append(bill)
                }
            } catch {
                completion(.failure(APIError.failToDecoding))
            }
            completion(.success(billArr))
        }
    }
    
    static func setBill(bill: Bill, uuid: String , completion: (Error?) -> Void) {
        var billArr: [Bill] = []
        let documentListener = Firestore.firestore().collection("BillList").document("\(uuid)")
        
        documentListener.getDocument { (snapshot, error) in
            if error != nil {
                return
            }
            guard let snapshot = snapshot else { return }
            
            if let billListData = snapshot.data()?["bill"] as? [[String:Any]] {
                
                do {
                    for billList in billListData {
                        let billData = try JSONSerialization.data(withJSONObject: billList)
                        let bill = try JSONDecoder().decode(Bill.self, from: billData)
                        billArr.append(bill)
                        
                    }
                } catch {
                    print("changmin - \(error.localizedDescription)")
                }
                billArr.append(bill)
                
                let billList = BillList(billList: billArr)
                try! documentListener.setData(from: billList)
                
            } else {
                try! documentListener.setData(from: BillList(billList: [bill]))
            }
        }
    }
}
