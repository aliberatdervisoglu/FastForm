//
//  FormResponsesListViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 21.03.2026.
//

import Foundation
import Combine
import FirebaseFirestore

class FormResponsesListViewViewModel: ObservableObject {
    @Published var responses: [FormResponce] = []
    @Published var isLoading = false
    
    private let db = Firestore.firestore()
    
    func fetchResponses(ownerId: String, formId: String) {
        isLoading = true
        
        db.collection("users").document(ownerId)
            .collection("forms").document(formId)
            .collection("responses")
            .order(by: "submittedDate", descending: true)
            .addSnapshotListener { querySnapshot, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    guard let documents = querySnapshot?.documents else { return }
                    
                    self.responses = documents.compactMap { doc -> FormResponce? in
                        try? doc.data(as: FormResponce.self)
                    }
                }
            }
    }
}
