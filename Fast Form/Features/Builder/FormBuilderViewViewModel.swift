
import Foundation

@Observable
final class FormBuilderViewViewModel {
    // MARK: - Properties

    @MainActor var showNewQuestionSheet: Bool = false
    @MainActor var title: String = ""

    private let formService: FormManager

    // MARK: - Init

    init(formService: FormManager = FormManagerImpl()) {
        self.formService = formService
    }

    // MARK: - Public Functions

    @MainActor
    func save(item: FormModel) async throws(FormManagerError) {
        try validateFormMetadata(item)

        do {
            try await formService.saveForm(form: item)
        } catch {
            throw error
        }
    }

    func createNewQuestion(type: QuestionType = .shortAnswer) -> Question {
        Question(id: UUID().uuidString, title: "", type: type, isRequired: false, options: [])
    }

    // MARK: - Private Validation Ranks

    private func validateFormMetadata(_ item: FormModel) throws(FormManagerError) {
        let trimmedTitle = item.title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            throw .databaseError("Please enter a valid title for your form!")
        }

        guard trimmedTitle.count >= 3 else {
            throw .titleTooShort
        }

        guard trimmedTitle.count >= 3 else {
            throw .databaseError("Form title is too short! It must be at least 3 characters.")
        }

        guard trimmedTitle.count <= 50 else {
            throw .databaseError("Form title is too long! Maximum character limit is 50.")
        }
    }
}
