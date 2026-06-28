//
//  SettingsViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation

@Observable
class SettingsViewViewModel {
    // MARK: - Properties

    @MainActor var isLoading = false
    @MainActor var showReauthAlert = false

    private let authService: AuthServiceProtocol

    // MARK: - Init

    init(authService: AuthServiceProtocol = AuthManager()) {
        self.authService = authService
    }

    // MARK: - Public Functions

    @MainActor
    func updateName(newName: String) async throws(AuthServiceError) {
        let trimmedname = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedname.isEmpty else {
            throw AuthServiceError.unknown("Name field is empty.")
        }
        isLoading = true

        defer {
            self.isLoading = false
        }

        do {
            try await authService.updateUserName(newName: trimmedname)
        } catch {
            throw error
        }
    }

    @MainActor
    func sendPasswordReset() async throws(AuthServiceError) {
        isLoading = true

        defer {
            self.isLoading = false
        }
        do {
            try await authService.sendPasswordReset()
        } catch {
            throw error
        }
    }

    @MainActor
    func logOut() throws(AuthServiceError) {
        isLoading = true
        try authService.signOut()
    }

    @MainActor
    func deleteAccount() async throws(AuthServiceError) {
        isLoading = true

        defer {
            self.isLoading = false
        }
        do {
            try await authService.deleteAccount()
        } catch {
            if error == AuthServiceError.requiresRecentLogin {
                showReauthAlert = true
            }
            throw error
        }
    }
}
