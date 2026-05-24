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

    var showNewQuestionSheet: Bool = false
    var title: String = ""
    var errorMessage: String = ""

    private let formService: FormServiceProtocol

    // MARK: - Init

    init(formService: FormServiceProtocol = FormManager()) {
        self.formService = formService
    }

    // MARK: - Public Functions

    func save(item: FormModel) {
        errorMessage = ""
        Task {
            do {
                try await formService.saveForm(form: item)
            } catch let error as FormServiceError {
                await MainActor.run {
                    self.errorMessage = error.errorDescription
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func createNewQuestion(type: QuestionType = .shortAnswer) -> Question {
        Question(id: UUID().uuidString, title: "", type: type, isRequired: false, options: [])
    }
}
