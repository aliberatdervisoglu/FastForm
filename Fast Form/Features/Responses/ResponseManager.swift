//
//  ResponseManager.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 12.05.2026.
//

import FirebaseFirestore
import Foundation

class ResponseManager: ResponseServiceProtocol {
    private let db = Firestore.firestore()

    ///***** Should I use AsynStream instead of this closures
    func observeResponse(ownerId: String, formId: String, completion: @escaping (Result<[FormResponce], any Error>) -> Void) -> Abortable {
        guard !ownerId.isEmpty, !formId.isEmpty else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "ID'ler eksik!"])))
            print("Invalid Parameters")
            return AnyAbortable {}
        }
        let listener = db.collection("users").document(ownerId)
            .collection("forms").document(formId)
            .collection("responses")
            .order(by: "submittedDate", descending: true)
            .addSnapshotListener { QuerySnapshot, error in
                if let error {
                    completion(.failure(error))
                    return
                }
                let responses = QuerySnapshot?.documents.compactMap { doc in
                    try? doc.data(as: FormResponce.self)
                } ?? []
                completion(.success(responses))
            }
        return AnyAbortable {
            listener.remove()
        }
    }

    func searchForms(query: String) async throws -> [FormModel] {
        let querySnapshot = try await db.collectionGroup("forms")
            .whereField("title", isGreaterThanOrEqualTo: query)
            .whereField("title", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments()
        let forms = querySnapshot.documents.compactMap { doc in
            try? doc.data(as: FormModel.self)
        }
        return forms
    }

    func submitResponse(ownerId: String, formId: String, response: FormResponce) async throws {
        guard !ownerId.isEmpty, !formId.isEmpty, !response.id.isEmpty else {
            throw NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document path IDs cannot be empty"])
        }

        let ref = db.collection("users").document(ownerId)
            .collection("forms").document(formId)
            .collection("responses").document(response.id)

        try await ref.setData(response.asDictionary())
    }
}
