//
//  FormBuilderViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation
import Combine

class FormBuilderViewViewModel: ObservableObject {
    @Published var showNewQuestionSheet: Bool = false
    @Published var title: String = ""
    
    private let formService: FormServiceProtocol
    
    init(formService: FormServiceProtocol = FormManager()) {
        self.formService = formService
    }
    
    func save(item: FormModel) {
        
        formService.saveForm(form: item) { result in
            switch result {
            case .success:
                print("Saved successfuly! ")
            case .failure(let error):
                print("Error: \(error.localizedDescription) ")
            }
        }
    }
    
    func createNewQuestion(type: QuestionType = .shortAnswer) -> Question {
        return Question(id: UUID().uuidString, title: "",type: type, isRequired: false, options: [])
    }
}
