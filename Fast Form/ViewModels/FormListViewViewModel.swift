//
//  FormListViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 22.02.2026.
//

import Foundation
import Combine
import FirebaseFirestore


class FormListViewViewModel: ObservableObject {
    @Published var formitems: [FormModel] = []
    
    private let userId: String
    
    init(userID: String){
        self.userId = userID
    }
    
    func deleteForm(id: String){
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("forms")
            .document(id)
            .delete() { error in
                if let error = error{
                    print("Delete Error: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.formitems.removeAll { $0.id == id}
                    }
                }
            }
        
    }
    
    
}
