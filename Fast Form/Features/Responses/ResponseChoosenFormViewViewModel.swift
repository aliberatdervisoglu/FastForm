//
//  ResponseChoosenFormViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.03.2026.
//

import Foundation

@Observable
class ResponseChoosenFormViewViewModel {
    // MARK: - Properties

    @MainActor var isLoading: Bool = false

    private let responseService: ResponseServiceProtocol
    private let authService: AuthServiceProtocol

    // MARK: - Init

    init(responseService: ResponseServiceProtocol = ResponseManager(), authService: AuthServiceProtocol = AuthManager()) {
        self.responseService = responseService
        self.authService = authService
    }

    // MARK: - Public Functions

    func validateAnswers(form: FormModel, answers: [String: Answer]) throws(ResponseServiceError) {
        for question in form.questionList {
            let answer = answers[question.id]

            if let answerValue = answer?.value {
                if question.type == .shortAnswer || question.type == .paragraph {
                    if answerValue.count > question.maxCharactersLimit {
                        throw .validationFailed(
                            questionId: question.id,
                            message: "\(question.title): answer is too long. Character limit (\(question.maxCharactersLimit)) exceeded!"
                        )
                    }
                }
            }

            if question.isRequired {
                if answer == nil {
                    throw .validationFailed(questionId: question.id, message: "Please fill: \(question.title)")
                }

                switch question.type {
                case .shortAnswer, .paragraph, .dropdown, .multipleChoice:
                    if answer?.value?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                        throw .validationFailed(questionId: question.id, message: "Required field: \(question.title)")
                    }
                case .checkboxes:
                    if answer?.selections?.isEmpty ?? true {
                        throw .validationFailed(questionId: question.id, message: "Choose at least one: \(question.title)")
                    }
                case .toggle:
                    if answer?.booleanValue != true {
                        throw .validationFailed(questionId: question.id, message: "Approval required: \(question.title)")
                    }
                }
            }
        }
    }

    @MainActor
    func submitForm(form: FormModel, answers: [String: Answer]) async throws(ResponseServiceError) {
        try validateAnswers(form: form, answers: answers)
        isLoading = true

        defer {
            isLoading = false
        }
        var info: RespondentInfo? = nil

        if !form.isAnonymus, let currentUser = authService.currentUser {
            info = RespondentInfo(
                id: currentUser.id,
                email: currentUser.email
            )
        }

        let newResponse = FormResponse(
            formId: form.id,
            info: info,
            answers: answers,
            submittedDate: Date()
        )

        do {
            try await responseService.submitResponse(ownerId: form.ownerId, formId: form.id, response: newResponse)
        } catch {
            throw error
        }
    }
}
