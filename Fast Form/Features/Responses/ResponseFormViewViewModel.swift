
import Foundation

@MainActor
@Observable
final class ResponseFormViewViewModel {
    // MARK: - Properties

    var searchText: String = ""
    var results: [FormModel] = []
    var isLoading: Bool = false

    private let responseService: ResponseManager

    // MARK: - Init

    init(responseService: ResponseManager? = nil) {
        self.responseService = responseService ?? ResponseManagerImpl()
    }

    // MARK: - Public Functions

    func searchForms() async throws(ResponseManagerError) {
        guard searchText.count >= 3 else {
            results = []
            return
        }

        isLoading = true

        defer {
            isLoading = false
        }

        do {
            results = try await responseService.searchForms(query: searchText)
        } catch {
            results = []
            throw error
        }
    }
}
