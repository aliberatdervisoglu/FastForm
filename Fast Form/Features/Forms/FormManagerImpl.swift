
import FirebaseFirestore
import Foundation

final class FormManagerImpl: FormManager {
    // MARK: - Properties

    private let db = Firestore.firestore()

    private let authService: AuthManager

    // MARK: - Initalizer

    init(authService: AuthManager = AuthManagerImpl()) {
        self.authService = authService
    }

    // MARK: - Public / Internal Functions (Accessible from ViewModels)

    /// ***** Should I use AsynStream instead of this closures
    func observeForms(userId: String, completion: @escaping (Result<[FormModel], FormManagerError>) -> Void) -> Abortable {
        let listener = db.collection("users")
            .document(userId)
            .collection("forms")
            .addSnapshotListener { snapshot, error in
                if let error {
                    completion(.failure(.databaseError(error.localizedDescription)))
                    return
                }

                let snapshotDocuments = snapshot?.documents ?? []
                var forms: [FormModel] = []

                for eachDocument in snapshotDocuments {
                    do {
                        let form = try eachDocument.data(as: FormModel.self)
                        forms.append(form)
                    } catch {
                        completion(.failure(.decodingError))
                        return
                    }
                }

                completion(.success(forms))
            }
        return AnyAbortable {
            listener.remove()
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
