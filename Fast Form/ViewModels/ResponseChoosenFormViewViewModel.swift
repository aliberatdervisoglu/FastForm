//
//  ResponseChoosenFormViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.03.2026.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class ResponseChoosenFormViewViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showAlert: Bool = false
    
    private var db = Firestore.firestore()
    
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
        
        let currentUserId = Auth.auth().currentUser?.uid
        let respondentId = form.isAnonymus ? nil : currentUserId
        
        let newResponse = FormResponce(
            formId: form.id,
            respondentId: respondentId,
            answers: answers,
            submittedDate: Date()
        )
        
        let ref = db.collection("users").document(form.ownerId)
                    .collection("forms").document(form.id)
                    .collection("responses").document(newResponse.id)
        
        do {
            try ref.setData(from: newResponse) { error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        self.showError(message: "Gönderilirken hata oluştu: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        completion(true) 
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.showError(message: "Veri dönüştürme hatası!")
                completion(false)
            }
        }
    }
    
    private func showError(message: String) {
        self.errorMessage = message
        self.showAlert = true
    }
}
