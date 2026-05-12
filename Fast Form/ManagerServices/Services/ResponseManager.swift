//
//  ResponseManager.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 12.05.2026.
//

import Foundation
import FirebaseFirestore

class ResponseManager: ResponseServiceProtocol {
    private let db = Firestore.firestore()
    
    func observeResponse(ownerId: String, formId: String, completion: @escaping (Result<[FormResponce], any Error>) -> Void) -> ServiceCancellable? {
        
        
        guard !ownerId.isEmpty, !formId.isEmpty else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "ID'ler eksik!"])))
            print("Invalid Parameters")
            return nil
        }
        let listener = db.collection("users").document(ownerId)
            .collection("forms").document(formId)
            .collection("responses")
            .order(by: "submittedDate", descending: true)
            .addSnapshotListener { QuerySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                let responses = QuerySnapshot?.documents.compactMap { doc in
                    try? doc.data(as: FormResponce.self)
                } ?? []
                completion(.success(responses))
            }
        return FirestoreCancellable(listener)
    }
    
    func searchForms(query: String, completion: @escaping (Result<[FormModel], any Error>) -> Void) {
        db.collectionGroup("forms")
            .whereField("title", isGreaterThanOrEqualTo: query)
            .whereField("title", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments { QuerySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                DispatchQueue.main.async {
                    let forms = QuerySnapshot?.documents.compactMap { doc in
                        try? doc.data(as: FormModel.self)
                    } ?? []
                    
                    completion(.success(forms))
                }
            }
    }
    
    func submitResponse(ownerId: String, formId: String, response: FormResponce, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard !ownerId.isEmpty, !formId.isEmpty, !response.id.isEmpty else {
                completion(.failure(NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document path IDs cannot be empty"])))
                return
            }
        
        let ref = db.collection("users").document(ownerId)
            .collection("forms").document(formId)
            .collection("responses").document(response.id)
        
        do {
            try ref.setData(from: response) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
}
