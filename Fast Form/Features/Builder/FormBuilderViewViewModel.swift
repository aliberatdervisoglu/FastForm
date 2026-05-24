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

    private let formService: FormServiceProtocol

    // MARK: - Init

    init(formService: FormServiceProtocol = FormManager()) {
        self.formService = formService
    }

    // MARK: - Public Functions

    func save(item: FormModel) {
        Task {
            do {
                try await formService.saveForm(form: item)
                print("Saved successfuly! ")
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func createNewQuestion(type: QuestionType = .shortAnswer) -> Question {
        Question(id: UUID().uuidString, title: "", type: type, isRequired: false, options: [])
    }
}
