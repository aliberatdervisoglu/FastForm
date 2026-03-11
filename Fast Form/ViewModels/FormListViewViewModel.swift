//
//  FormListViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 22.02.2026.
//

import Foundation
import Combine
import FirebaseFirestore

enum FormSortOption: String, CaseIterable { //  Sort options for formlist
    case newest = "Newest First"
    case oldest = "Oldest First"
    case aToZ = "A - Z"
    case zToA = "Z - A"
}



class FormListViewViewModel: ObservableObject {
    @Published var formitems: [FormModel] = []
    @Published var sortOption: FormSortOption = .newest //  it is published an if it is changed, all modules run again like 'sortedForms'
    
    private let userId: String
    private var listenerRegistration: ListenerRegistration?
    
    var sortedforms: [FormModel] { // works about current sort option and resort the forms.
        switch sortOption {
        case .newest:
            return formitems.sorted { $0.createDate > $1.createDate }
        case .oldest:
            return formitems.sorted { $0.createDate < $1.createDate }
        case .aToZ:
            return formitems.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .zToA:
            return formitems.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedDescending }
        }
    }
    
    init(userID: String){
        self.userId = userID
    }
    
    
    
    func fetchForms(){
        let db = Firestore.firestore()
        
        listenerRegistration?.remove()
        
        listenerRegistration = db.collection("users")
            .document(userId)
            .collection("forms")
            .addSnapshotListener { [weak self] snapshot, error in
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                DispatchQueue.main.async {
                    self?.formitems = snapshot?.documents.compactMap { doc in
                        try? doc.data(as: FormModel.self)
                        
                    } ?? []
                }
                    
                
        }
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
    deinit {
        listenerRegistration?.remove()
    }
    
    
}
