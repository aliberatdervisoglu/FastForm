//
//  FormManager.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 11.05.2026.
//

import Foundation
import FirebaseFirestore

class FormManager: FormServiceProtocol {
    private let db = Firestore.firestore()
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthManager()) {
        self.authService = authService
    }
    
    func observeForms(userId: String, completion: @escaping (Result<[FormModel], any Error>) -> Void) -> ServiceCancellable? {
        let listener = db.collection("users")
            .document(userId)
            .collection("forms")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                let forms = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: FormModel.self)
                } ?? []
                
                completion(.success(forms))
            }
        return FirestoreCancellable(listener)
    }
    func deleteForm(userId: String, formId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users")
            .document(userId)
            .collection("forms")
            .document(formId)
            .delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
    func saveForm(form: FormModel, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let uid = authService.currentUserID else {
            completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı bulunamadı"])))
            return
        }
        
        var handleItem = form
        handleItem.ownerId = uid

        db.collection("users")
            .document(uid)
            .collection("forms")
            .document(handleItem.id)
            .setData(handleItem.asDictionary()) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }

}
    
