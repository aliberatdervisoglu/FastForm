
import Foundation

@MainActor
@Observable
final class FormResponsesListViewViewModel {
    // MARK: - Properties

    var responses: [FormResponse] = []
    var isLoading = false
    var errorMessage: String = ""

    private let responseService: ResponseManager
    private var responseAbortable: Abortable?

    // MARK: - Init

    init(responseService: ResponseManager? = nil) {
        self.responseService = responseService ?? ResponseManagerImpl()
    }

    // MARK: - Public Functions

    func fetchResponses(ownerId: String, formId: String) {
        isLoading = true
        errorMessage = ""

        responseAbortable?.cancel()

        responseAbortable = responseService.observeResponse(ownerId: ownerId, formId: formId) { @MainActor [weak self] result in
            guard let self else { return }

            isLoading = false

            switch result {
            case let .success(fetchedResponses):
                responses = fetchedResponses
            case let .failure(error):
                errorMessage = error.errorDescription
                responses = []
            }
        }
    }

    // MARK: - Lifecycle
    
//   it will be changed
//    deinit {
//        responseAbortable?.cancel()
//    }
}
