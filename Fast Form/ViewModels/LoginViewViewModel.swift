//
//  LoginViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation
import Combine
import FirebaseAuth

class LoginViewViewModel: ObservableObject{
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    
    init(){
        
    }
    func login(){
        errorMessage = ""
        
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            errorMessage = "Please fill in all the fields!"
            return
        }
        
        guard email.contains("@"), email.contains(".") else {
            errorMessage = "Please enter a valid email!"
            return
        }
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
}
