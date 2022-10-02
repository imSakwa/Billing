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
        let db = Firestore.firestore()
        
        db.collection("BillList").getDocuments { (snapshot, error) in
            if error != nil {
                completion(.failure(error!))
            }
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
        
                if document.documentID == "Bill" {
                    do {
                        for billList in (document.data()["bill"] as! [[String:Any]]) {
                            let billData = try JSONSerialization.data(withJSONObject: billList)
                            let bill = try JSONDecoder().decode(Bill.self, from: billData)
                            billArr.append(bill)
                        }
                    } catch {
                        print("changmin - \(error.localizedDescription)")
                    }
                }
            }
            
            completion(.success(billArr))
        }
    }
    
    static func setBill(bill: Bill, completion: ((Error?) -> Void)? = nil) {
        let collectionListener = Firestore.firestore().collection("BillList")
//        let encode = JSONEncoder.encode(bill.self)
        guard let object = try? JSONEncoder().encode(bill.self),
              let aaaa = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any] else { return }
        
        collectionListener.addDocument(data: aaaa) { error in
            completion?(error)
        }
    }
}
