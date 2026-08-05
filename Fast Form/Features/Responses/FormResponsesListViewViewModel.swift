
import FactoryKit
import Foundation

@MainActor
@Observable
final class FormResponsesListViewViewModel {
    // MARK: - Properties

    var responses: [FormResponse] = []
    var isLoading = false
    var errorMessage: String = ""

    @ObservationIgnored @Injected(\.responseService) private var responseService: ResponseManager
    private var responseTask: Task<Void, Never>?

    // MARK: - Public Functions

    func fetchResponses(ownerId: String, formId: String) {
        responseTask?.cancel()

        isLoading = true
        errorMessage = ""

        responseTask = Task {
            do {
                for try await fetchedResponses in responseService.observeResponse(ownerId: ownerId, formId: formId) {
                    self.responses = fetchedResponses
                    self.isLoading = false
                }
            } catch let error as ResponseManagerError {
                self.errorMessage = error.errorDescription
                self.responses = []
                self.isLoading = false
            } catch {
                // Genel/Beklenmeyen bir hata olursa yakalıyoruz
                self.errorMessage = error.localizedDescription
                self.responses = []
                self.isLoading = false
            }
        }
    }

    func cancelListening() {
        responseTask?.cancel()
        responseTask = nil
    }
}
