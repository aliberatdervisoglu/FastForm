
import Foundation

protocol ResponseManager {
    // MARK: - Public / Internal Functions (Accessible from ViewModels)

    func observeResponse(ownerId: String, formId: String) -> AsyncThrowingStream<[FormResponse], Error>
    
    func searchForms(query: String) async throws(ResponseManagerError) -> [FormModel]

    func submitResponse(ownerId: String, formId: String, response: FormResponse) async throws(ResponseManagerError)
}
