//
//  ResponseFormViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation
import Combine
import FirebaseFirestore

class ResponseFormViewViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var results: [FormModel] = []
    @Published var isLoading: Bool = false
    
    private var db = Firestore.firestore()
    
    init(){}
     
    func searchForms() {
        
        guard searchText.count >= 3 else {
                self.results = []
                return
            }
        
        self.isLoading = true
        
        db.collectionGroup("forms")
            .whereField("title", isGreaterThanOrEqualTo: searchText)
            .whereField("title", isLessThanOrEqualTo: searchText + "\u{f8ff}")
            .getDocuments { snapshot, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    
                    self.results = snapshot?.documents.compactMap { doc in
                        try? doc.data(as: FormModel.self)
                    } ?? []
                }
            }
    }
    
}
