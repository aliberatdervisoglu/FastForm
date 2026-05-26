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

    @MainActor var name: String = ""
    @MainActor var email: String = ""
    @MainActor var password: String = ""
    @MainActor var confirmPassword: String = ""

    @MainActor var isAuthenticating = false

    private let authService: AuthServiceProtocol

    // MARK: - Init

    init(authService: AuthServiceProtocol = AuthManager()) {
        self.authService = authService
    }

    // MARK: - Public Functions

    @MainActor
    func register() async throws(AuthServiceError) {
        try validate()

        isAuthenticating = true
        defer { isAuthenticating = false }
        do {
            try await authService.signUp(name: name, email: email, password: password)
        } catch {
            throw error
        }
    }

    // MARK: - Private Functions

    @MainActor
    private func validate() throws(AuthServiceError) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !confirmPassword.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            throw .unknown("Please fill in all the fields")
        }
        guard password == confirmPassword else {
            throw .unknown("Passwords do not match")
        }
        guard email.contains("@"), email.contains(".") else {
            throw .unknown("Please enter a valid email")
        }
        guard password.count >= 6 else {
            throw .unknown("Password must be at least 6 characters long")
        }
    }
}
