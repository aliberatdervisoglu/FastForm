//
//  SettingsViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation

@Observable
class SettingsViewViewModel {

    var errormeessage: String? = nil
    var isLoading = false
    var showReauthAlert = false
    
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthManager()) {
        self.authService = authService
    }

    func updateName(newName: String, completion: @escaping(Bool) -> Void) {
        let trimmedname = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedname.isEmpty else {
            self.errormeessage = "Name cannot be empty"
            completion(false)
            return
        }
        self.isLoading = true
        authService.updateUserName(newName: trimmedname) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    self?.errormeessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
    
    func sendPasswordReset(completion: @escaping (Bool) -> Void) {
        self.isLoading = true
        
        authService.sendPasswordReset { [weak self] result in
            
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    self?.errormeessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
    
    func logOut() {
        do {
            try authService.signOut()
        } catch {
            self.errormeessage = "Log Out failed: \(error.localizedDescription)"
        }
    }
    
    func deleteAccount(onSuccess: @escaping () -> Void) {
        
        self.isLoading = true // for just one touch to button
        
        authService.deleteAccount { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    onSuccess()
                case .failure(let error):
                    
                    if let authError = error as? AuthServiceError, authError == .requiresRecentLogin {
                        self?.showReauthAlert = true
                    } else {
                        self?.errormeessage = error.localizedDescription
                    }
                }
            }
        }
    }
    
}
