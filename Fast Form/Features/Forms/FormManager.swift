
import Foundation

protocol FormManager {
    // MARK: - Public / Internal Functions (Accessible from ViewModels)

    func observeForms(userId: String) -> AsyncThrowingStream<[FormModel], Error>
    
    func deleteForm(userId: String, formId: String) async throws(FormManagerError)

    func saveForm(form: FormModel) async throws(FormManagerError)
}
