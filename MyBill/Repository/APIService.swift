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
    
    
    static func getBillList() {
        let db = Firestore.firestore()
        
        db.collection("BillList").getDocuments { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
        
                if document.documentID == "Bill" {
                    let aa = try! document.data(as: Bill.self)
                    print("changmin - \(aa)")
                }
            }
        }
        
       
    }
}
