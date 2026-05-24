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
            self.errorMeessage = "Name cannot be empty."
            throw AuthServiceError.unknown("Name field is empty.")
        }
        self.isLoading = true
        self.errorMeessage = ""

        defer {
            self.isLoading = false
        }

        do {
            try await authService.updateUserName(newName: trimmedname)
        } catch {
            self.errorMeessage = error.errorDescription ?? "An unexpected error occured"
            throw error
        }
    }

    @MainActor
    func sendPasswordReset() async throws {
        self.errorMeessage = ""
        self.isLoading = true

        defer {
            self.isLoading = false
        }
        do {
            try await authService.sendPasswordReset()
        } catch {
            self.errorMeessage = error.errorDescription ?? "An unexpected error occured"
            throw error
        }
    }
    
    @MainActor
    func logOut() {
        self.errorMeessage = ""
        do {
            try authService.signOut()
        } catch {
            self.errorMeessage = error.errorDescription ?? "An unexpected error occured"
        }
    }

    @MainActor
    func deleteAccount() async throws {
        self.isLoading = true
        self.errorMeessage = ""

        defer {
            self.isLoading = false
        }
        do {
            try await authService.deleteAccount()
        } catch {
            if error == AuthServiceError.requiresRecentLogin {
                self.showReauthAlert = true
            }
            
            self.errorMeessage = error.errorDescription ?? "An unexpected error occured"
            throw error
        }
    }
}
