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
                        let bill = try document.data(as: Bill.self)
                        billArr.append(bill)
                        
                    } catch {
                        print("changmin - \(error.localizedDescription)")
                    }
                }
            }
            
            completion(.success(billArr))
        }
    }
}
