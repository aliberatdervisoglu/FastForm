
import Foundation

//  MARK: - Sort options for formlist

enum FormSortOption: String, CaseIterable {
    case newest = "Newest First"
    case oldest = "Oldest First"
    case aToZ = "A - Z"
    case zToA = "Z - A"
}

@MainActor
@Observable
final class FormListViewViewModel {
    // MARK: - Properties

    var formitems: [FormModel] = []
    var sortOption: FormSortOption = .newest //  it is published an if it is changed, all modules run again like 'sortedForms'
    var errorMessage: String = ""

    private let userId: String
    private var formService: FormManager
    private var formTask: Task<Void, Never>?

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

    init(userId: String, formService: FormManager) {
        self.formService = formService
        self.userId = userId
    }

    // MARK: - Public Functions

    func fetchForms() {
        formTask?.cancel() // Eski dinlemeyi iptal et (Savunmacı programlama)
        errorMessage = ""

        formTask = Task {
            do {
                for try await forms in formService.observeForms(userId: userId) {
                    self.formitems = forms
                }
            } catch let error as FormManagerError {
                self.errorMessage = error.errorDescription
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func deleteForm(id: String) async throws(FormManagerError) {
        try await formService.deleteForm(userId: userId, formId: id)
    }

    func cancelListening() {
        formTask?.cancel()
        formTask = nil
    }
}
