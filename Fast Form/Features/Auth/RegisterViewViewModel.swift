//
//  RegisterViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation

@Observable
class RegisterViewViewModel {
    // MARK: - Properties

    var name: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var errorMessage: String = ""

    private let authService: AuthServiceProtocol

    // MARK: - Init

    init(authService: AuthServiceProtocol = AuthManager()) {
        self.authService = authService
    }

    // MARK: - Public Functions

    func register() {
        guard validate() else { return }

        Task {
            do {
                try await authService.signUp(name: name, email: email, password: password)
            } catch let error as AuthServiceError {
                await MainActor.run {
                    self.errorMessage = error.errorDescription ?? "An error occurred. Please try again!"
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // MARK: - Private Functions

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
