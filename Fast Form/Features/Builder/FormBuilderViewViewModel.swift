//
//  FormBuilderViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation

@Observable
class FormBuilderViewViewModel {
    // MARK: - Properties

    @MainActor var showNewQuestionSheet: Bool = false
    @MainActor var title: String = ""

    private let formService: FormServiceProtocol

    // MARK: - Init

    init(formService: FormServiceProtocol = FormManager()) {
        self.formService = formService
    }

    // MARK: - Public Functions

    @MainActor
    func save(item: FormModel) async throws(FormServiceError) {
        do {
            try await formService.saveForm(form: item)
        } catch {
            throw error
        }
    }

    func createNewQuestion(type: QuestionType = .shortAnswer) -> Question {
        Question(id: UUID().uuidString, title: "", type: type, isRequired: false, options: [])
    }
}
