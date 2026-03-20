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
    
    func validateAnswers(form: FormModel, answers: [String: Answer]) -> Bool {
        for question in form.questionList {
            if question.isRequired {
                guard let answer = answers[question.id] else {
                    showError(message: "Please fill all required questions: \(question.title)")
                    return false
                }
                
                switch question.type {
                case .shortAnswer, .paragraph, .dropdown, .multipleChoice:
                    if answer.value?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                        showError(message: "Lütfen boş bırakmayın: \(question.title)")
                        return false
                    }
                case .checkboxes:
                    if answer.selections?.isEmpty ?? true {
                        showError(message: "Lütfen en az bir seçenek işaretleyin: \(question.title)")
                        return false
                    }
                case .toggle:
                    if answer.booleanValue != true {
                        showError(message: "Devam etmek için onaylamalısınız: \(question.title)")
                        return false
                    }
                }
            }
        }
        return true
    }
    
    
    func submitForm(form: FormModel, answers: [String: Answer], completion: @escaping (Bool) -> Void) {
        guard validateAnswers(form: form, answers: answers) else {
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
