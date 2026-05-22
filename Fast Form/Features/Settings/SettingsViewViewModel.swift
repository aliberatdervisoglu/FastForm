//
//  SettingsViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation

@Observable
class SettingsViewViewModel {
    var errormeessage: String?
    var isLoading = false
    var showReauthAlert = false

    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthManager()) {
        self.authService = authService
    }

    func updateName(newName: String, completion: @escaping (Bool) -> Void) {
        let trimmedname = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedname.isEmpty else {
            errormeessage = "Name cannot be empty"
            completion(false)
            return
        }
        isLoading = true
        authService.updateUserName(newName: trimmedname) { @MainActor [weak self] result in
            self?.isLoading = false
            switch result {
            case .success:
                completion(true)
            case let .failure(error):
                self?.errormeessage = error.localizedDescription
                completion(false)
            }
        }
    }

    func sendPasswordReset(completion: @escaping (Bool) -> Void) {
        isLoading = true

        authService.sendPasswordReset { @MainActor [weak self] result in
            self?.isLoading = false
            switch result {
            case .success:
                completion(true)
            case let .failure(error):
                self?.errormeessage = error.localizedDescription
                completion(false)
            }
        }
    }

    func logOut() {
        do {
            try authService.signOut()
        } catch {
            errormeessage = "Log Out failed: \(error.localizedDescription)"
        }
    }

    func deleteAccount(onSuccess: @escaping () -> Void) {
        isLoading = true // for just one touch to button

        authService.deleteAccount { @MainActor [weak self] result in
            self?.isLoading = false
            switch result {
            case .success:
                onSuccess()
            case let .failure(error):
                if let authError = error as? AuthServiceError, authError == .requiresRecentLogin {
                    self?.showReauthAlert = true
                } else {
                    self?.errormeessage = error.localizedDescription
                }
            }
        }
    }
}
