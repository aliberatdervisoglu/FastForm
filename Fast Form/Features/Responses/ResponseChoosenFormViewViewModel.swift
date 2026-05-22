//
//  ResponseChoosenFormViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.03.2026.
//

import Foundation

@Observable
class ResponseChoosenFormViewViewModel {
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var showAlert: Bool = false
    
    private let responseService: ResponseServiceProtocol
    private let authService: AuthServiceProtocol
    
    init(responseService: ResponseServiceProtocol = ResponseManager(), authService: AuthServiceProtocol = AuthManager()) {
        self.responseService = responseService
        self.authService = authService
    }
    
    
    func validateAnswers(form: FormModel, answers: [String: Answer]) -> String? {
        for question in form.questionList {
            
            let answer = answers[question.id]
            
            if let answerValue = answer?.value {
                if question.type == .shortAnswer || question.type == .paragraph {
                    if answerValue.count > question.maxCharactersLimit {
                        showError(message: "\(question.title): answer is too long. Character limit (\(question.maxCharactersLimit)) exceeded!")
                        return question.id
                    }
                }
            }
            
            if question.isRequired {
                if answer == nil {
                    showError(message: "Please fill: \(question.title)")
                    return question.id
                }
                
                switch question.type {
                case .shortAnswer, .paragraph, .dropdown, .multipleChoice:
                    if answer?.value?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                        showError(message: "Required field: \(question.title)")
                        return question.id
                    }
                case .checkboxes:
                    if answer?.selections?.isEmpty ?? true {
                        showError(message: "Choose at least one: \(question.title)")
                        return question.id
                    }
                case .toggle:
                    if answer?.booleanValue != true {
                        showError(message: "Approval required: \(question.title)")
                        return question.id
                    }
                }
            }
        }
        return nil
    }
    
    
    func submitForm(form: FormModel, answers: [String: Answer], completion: @escaping (Bool) -> Void) {
        guard (validateAnswers(form: form, answers: answers) == nil) else {
            completion(false)
            return
        }
        
        isLoading = true
        
        var info: RespondentInfo? = nil
        
        if !form.isAnonymus, let userId = authService.currentUserID, let userEmail = authService.currentUserEmail {
            info = RespondentInfo(
                id: userId,
                email: userEmail
            )
        }
        
        let newResponse = FormResponce(
            formId: form.id,
            info: info,
            answers: answers,
            submittedDate: Date()
        )
        
        responseService.submitResponse(ownerId: form.ownerId, formId: form.id, response: newResponse) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    self?.showError(message: "Error: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
    
    private func showError(message: String) {
        self.errorMessage = message
        self.showAlert = true
    }
}
