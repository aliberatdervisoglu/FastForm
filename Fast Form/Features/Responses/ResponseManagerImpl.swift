
import FirebaseFirestore
import Foundation

final class ResponseManagerImpl: ResponseManager {
    // MARK: - Properties

    private var db: Firestore {
        Firestore.firestore()
    }

    // MARK: - Public / Internal Functions (Accessible from ViewModels)

    func observeResponse(ownerId: String, formId: String) -> AsyncThrowingStream<[FormResponse], Error> {
        AsyncThrowingStream([FormResponse].self) { continuation in
            guard !ownerId.isEmpty, !formId.isEmpty else {
                continuation.finish(throwing: ResponseManagerError.invalidParameters)
                return
            }
            let listener = db.collection("users").document(ownerId)
                .collection("forms").document(formId)
                .collection("responses")
                .order(by: "submittedDate", descending: true)
                .addSnapshotListener { snapshot, error in
                    if let error {
                        continuation.finish(throwing: ResponseManagerError.databaseError(error.localizedDescription))
                        return
                    }
                    let snapshotDocuments = snapshot?.documents ?? []

                    let responses = snapshotDocuments.compactMap { doc in
                        try? doc.data(as: FormResponse.self)
                    }
                    continuation.yield(responses)
                }
            continuation.onTermination = { _ in
                listener.remove()
            }
        }
    }

    func searchForms(query: String) async throws(ResponseManagerError) -> [FormModel] { // MARK: - I now that this is not productive large-scaled. But I don't need in this project.

        let snapshot: QuerySnapshot
        do {
            snapshot = try await db.collectionGroup("forms")
                .getDocuments()
        } catch {
            throw .databaseError(error.localizedDescription)
        }
        var forms: [FormModel] = []
        let lowerQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        for eachDocument in snapshot.documents {
            do {
                let form = try eachDocument.data(as: FormModel.self)

                let matchesTitle = form.title.localizedCaseInsensitiveContains(lowerQuery)
                let matchesExplanation = form.explanation.localizedCaseInsensitiveContains(lowerQuery)
                if matchesTitle || matchesExplanation {
                    forms.append(form)
                }
            } catch {
                throw .decodingError
            }
        }
        return forms
    }

    func submitResponse(ownerId: String, formId: String, response: FormResponse) async throws(ResponseManagerError) {
        guard !ownerId.isEmpty, !formId.isEmpty, !response.id.isEmpty else {
            throw .invalidParameters
        }

        // It is just a local reference to the path (no network request yet)
        let ref = db.collection("users").document(ownerId)
            .collection("forms").document(formId)
            .collection("responses").document(response.id)

        do {
            try ref.setData(from: response)
        } catch {
            throw .databaseError(error.localizedDescription)
        }
    }
}
