//
//  FormBuilderViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class FormBuilderViewViewModel: ObservableObject {
    @Published var showNewQuestionSheet: Bool = false
    @Published var title: String = ""
    init() {
        
    }
    
    func save (item: FormModel) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        var handleItem = item
        handleItem.ownerId = userID
         
        db.collection("users")
            .document(userID)
            .collection("forms")
            .document(handleItem.id)
            .setData(handleItem.asDictionary())
    }
    
    func createNewQuestion(type: QuestionType = .shortAnswer) -> Question {
        return Question(id: UUID().uuidString, title: "",type: type, isRequired: false, options: [])
    }
    
}
