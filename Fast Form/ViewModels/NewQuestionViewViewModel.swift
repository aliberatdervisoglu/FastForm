//
//  NewQuestionViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation
import Combine

class NewQuestionViewViewModel: ObservableObject {
    
    @Published var question: Question // to hold copy of current question and it provides that close the sheet without changes
    
    init(question: Question) {
        self.question = question // take a copy
    }
    
    func save(completion: @escaping (Question) -> Void){
        
        if question.title.trimmingCharacters(in: .whitespaces).isEmpty{
            print("The title cannot be empty!")
        }
        completion(self.question) // to give View as parameter completion and we will give a name like updatedQuestion
        // execute the function who takes the queston as a parameter and return void. ant he question actually has not name in this function.
        // -> go to NewQuestionView and continue
    }
}
