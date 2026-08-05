
import FactoryKit
import Foundation

@MainActor
@Observable
final class ResponseFormViewViewModel {
    // MARK: - Properties

    var searchText: String = ""
    var results: [FormModel] = []
    var isLoading: Bool = false

    @ObservationIgnored @Injected(\.responseService) private var responseService: ResponseManager

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
