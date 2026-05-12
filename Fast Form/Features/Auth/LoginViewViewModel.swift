//
//  LoginViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation
import Combine

class LoginViewViewModel: ObservableObject{
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthManager()){
        self.authService = authService
    }
    func login(){
        guard validate() else {return}
        authService.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                break
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    private func validate() -> Bool{
        errorMessage = ""
        
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            errorMessage = "Please fill in all the fields!"
            return false
        }
        guard email.contains("@"), email.contains(".") else {
            errorMessage = "Please enter a valid email!"
            return false
        }
        return true
    }
}
