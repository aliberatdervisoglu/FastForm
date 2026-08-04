
import FirebaseFirestore
import Foundation

final class FormManagerImpl: FormManager {
    // MARK: - Properties

    private var db: Firestore {
        Firestore.firestore()
    }

    private let authService: AuthManager

    // MARK: - Initalizer

    init(authService: AuthManager = AuthManagerImpl()) {
        self.authService = authService
    }

    // MARK: - Public / Internal Functions (Accessible from ViewModels)

    func observeForms(userId: String) -> AsyncThrowingStream<[FormModel], Error> {
        AsyncThrowingStream([FormModel].self) { continuation in
            let listener = db.collection("users")
                .document(userId)
                .collection("forms")
                .addSnapshotListener { snapshot, error in
                    if let error {
                        continuation.finish(throwing: FormManagerError.databaseError(error.localizedDescription))
                        return
                    }

                    let snapshoDocuments = snapshot?.documents ?? []

                    let forms: [FormModel] = snapshoDocuments.compactMap { doc in
                        try? doc.data(as: FormModel.self)
                    }
                    continuation.yield(forms)
                }
            continuation.onTermination = { _ in
                listener.remove()
            }
        }
    }

    func deleteForm(userId: String, formId: String) async throws(FormManagerError) {
        do {
            try await db.collection("users")
                .document(userId)
                .collection("forms")
                .document(formId)
                .delete()
        } catch {
            throw .databaseError(error.localizedDescription)
        }
    }

    func saveForm(form: FormModel) async throws(FormManagerError) {
        guard let uid = authService.currentUser?.id else {
            throw .userNotFound
        }

        var handleItem = form
        handleItem.ownerId = uid

        do {
            try await db.collection("users")
                .document(uid)
                .collection("forms")
                .document(handleItem.id)
                .setData(handleItem.asDictionary())
        } catch {
            throw .databaseError(error.localizedDescription)
        }
    }
}
