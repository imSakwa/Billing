//
//  APIService.swift
//  MyBill
//
//  Created by ChangMin on 2022/09/25.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore


final class APIService {
    
    static func getBillList(completion: @escaping (Result<[Bill], Error>) -> Void) {
        var billArr: [Bill] = []
        let documentListener = Firestore.firestore().collection("BillList").document("Bill")
        
        documentListener.getDocument { (snapshot, error) in
            if error != nil {
                completion(.failure(error!))
            }
            guard let snapshot = snapshot else { return }
            
            do {
                for billList in (snapshot.data()?["bill"] as! [[String:Any]]) {
                    let billData = try JSONSerialization.data(withJSONObject: billList)
                    let bill = try JSONDecoder().decode(Bill.self, from: billData)
                    billArr.append(bill)
                }
            } catch {
                print("changmin - \(error.localizedDescription)")
            }
            completion(.success(billArr))
        }
    }
    
    static func setBill(bill: Bill, completion: (Error?) -> Void) {
        var billArr: [Bill] = []
        let documentListener = Firestore.firestore().collection("BillList").document("Bill")
        
        documentListener.getDocument { (snapshot, error) in
            if error != nil {
                return
            }
            guard let snapshot = snapshot else { return }
            
            do {
                for billList in (snapshot.data()?["bill"] as! [[String:Any]]) {
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
        }
    }
}
