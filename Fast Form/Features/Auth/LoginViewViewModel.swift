//
//  LoginViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation

@Observable
class LoginViewViewModel {
    // MARK: - Properties

    @MainActor var email: String = ""
    @MainActor var password: String = ""

    private let authService: AuthServiceProtocol

    // MARK: - Init

    init(authService: AuthServiceProtocol = AuthManager()) {
        self.authService = authService
    }

    // MARK: - Public Functions

    @MainActor
    func login() async throws(AuthServiceError) {
        try validate()
        
        do {
            try await authService.signIn(email: email, password: password)
        } catch {
            throw error
        }
    }

    // MARK: - Private Functions

    private func validate() throws(AuthServiceError) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            throw .unknown("Please fill in all the fields!")
        }

        guard email.contains("@"), email.contains(".") else {
            throw .unknown("Please enter a valid email!")
        }
    }
}
