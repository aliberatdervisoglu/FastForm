//
//  RegisterViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation

@Observable
class RegisterViewViewModel{
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var errorMessage: String = ""
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthManager()){
        self.authService = authService
    }
    
    func register(){
        guard validate() else { return }
        
        authService.signUp(name: name, email: email, password: password) { @MainActor [weak self] result in
            switch result {
            case .success:
                break
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    
    }
    
    private func validate() -> Bool {
        errorMessage = ""
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !confirmPassword.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            errorMessage = "Please fill in all the fields"
            return false
        }
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return false
        }
        guard email.contains("@"), email.contains(".") else {
            errorMessage = "Please enter a valid email"
            return false
        }
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters long"
            return false
        }
        
        return true
    }
}
