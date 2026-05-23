//
//  FormManager.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 11.05.2026.
//

import FirebaseFirestore
import Foundation

class FormManager: FormServiceProtocol {
    private let db = Firestore.firestore()
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthManager()) {
        self.authService = authService
    }

    /// ***** Should I use AsynStream instead of this closures
    func observeForms(userId: String, completion: @escaping (Result<[FormModel], any Error>) -> Void) -> Abortable {
        let listener = db.collection("users")
            .document(userId)
            .collection("forms")
            .addSnapshotListener { snapshot, error in
                if let error {
                    completion(.failure(error))
                    return
                }
                let forms = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: FormModel.self)
                } ?? []

                completion(.success(forms))
            }
        return AnyAbortable {
            listener.remove()
        }
    }

    func deleteForm(userId: String, formId: String) async throws {
        try await db.collection("users").document(userId).collection("forms").document(formId).delete()
    }

    func saveForm(form: FormModel) async throws {
        guard let uid = authService.currentUser?.id else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User cannot found"])
        }

        var handleItem = form
        handleItem.ownerId = uid

        try await db.collection("users")
            .document(uid)
            .collection("forms")
            .document(handleItem.id)
            .setData(handleItem.asDictionary())
    }
}
