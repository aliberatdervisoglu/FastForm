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

    @MainActor var errorMeessage: String = ""
    @MainActor var isLoading = false
    @MainActor var showReauthAlert = false

    private let authService: AuthServiceProtocol

    // MARK: - Init

    init(authService: AuthServiceProtocol = AuthManager()) {
        self.authService = authService
    }

    // MARK: - Public Functions

    @MainActor
    func updateName(newName: String) async throws {
        let trimmedname = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedname.isEmpty else {
            errorMeessage = "Name cannot be empty."
            throw AuthServiceError.unknown("Name field is empty.")
        }
        isLoading = true
        errorMeessage = ""

        defer {
            self.isLoading = false
        }

        do {
            try await authService.updateUserName(newName: trimmedname)
        } catch {
            errorMeessage = error.errorDescription ?? "An unexpected error occured"
            throw error
        }
    }

    @MainActor
    func sendPasswordReset() async throws {
        errorMeessage = ""
        isLoading = true

        defer {
            self.isLoading = false
        }
        do {
            try await authService.sendPasswordReset()
        } catch {
            errorMeessage = error.errorDescription ?? "An unexpected error occured"
            throw error
        }
    }

    @MainActor
    func logOut() {
        errorMeessage = ""
        do {
            try authService.signOut()
        } catch {
            errorMeessage = error.errorDescription ?? "An unexpected error occured"
        }
    }

    @MainActor
    func deleteAccount() async throws {
        isLoading = true
        errorMeessage = ""

        defer {
            self.isLoading = false
        }
        do {
            try await authService.deleteAccount()
        } catch {
            if error == AuthServiceError.requiresRecentLogin {
                showReauthAlert = true
            }

            errorMeessage = error.errorDescription ?? "An unexpected error occured"
            throw error
        }
    }
}
