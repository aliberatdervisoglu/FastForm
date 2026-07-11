
import Foundation

//  MARK: - Sort options for formlist

enum FormSortOption: String, CaseIterable {
    case newest = "Newest First"
    case oldest = "Oldest First"
    case aToZ = "A - Z"
    case zToA = "Z - A"
}

@Observable
final class FormListViewViewModel {
    // MARK: - Properties

    @MainActor var formitems: [FormModel] = []
    @MainActor var sortOption: FormSortOption = .newest //  it is published an if it is changed, all modules run again like 'sortedForms'
    @MainActor var errorMessage: String = ""

    private let userId: String
    private var formService: FormManager
    private var formAbortable: Abortable?

    @MainActor
    var sortedforms: [FormModel] { // works about current sort option and resort the forms.
        switch sortOption {
        case .newest:
            formitems.sorted { $0.createDate > $1.createDate }
        case .oldest:
            formitems.sorted { $0.createDate < $1.createDate }
        case .aToZ:
            formitems.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .zToA:
            formitems.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedDescending }
        }
    }

    // MARK: - Init

    init(userId: String, formService: FormManager = FormManagerImpl()) {
        self.userId = userId
        self.formService = formService
    }

    // MARK: - Public Functions

    @MainActor
    func fetchForms() {
        formAbortable?.cancel()
        errorMessage = ""

        formAbortable = formService.observeForms(userId: userId) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(forms):
                formitems = forms
            case let .failure(error):
                errorMessage = error.errorDescription
            }
        }
    }

    @MainActor
    func deleteForm(id: String) async throws(FormManagerError) {
        do {
            try await formService.deleteForm(userId: userId, formId: id)
        } catch {
            throw error
        }
    }

    // MARK: - Lifecycle

    deinit {
        formAbortable?.cancel()
    }
}
