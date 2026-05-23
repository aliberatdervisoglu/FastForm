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

    func updateName(newName: String) async throws {
        let trimmedname = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedname.isEmpty else {
            await MainActor.run {
                self.errormeessage = "Name cannot be empty."
            }
            throw NSError(domain: "ProfileViewViewModel", code: 400, userInfo: [NSLocalizedDescriptionKey: "Name cannot be empty."])
        }
        await MainActor.run {
            self.isLoading = true
        }

        defer {
            Task {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }

        do {
            try await authService.updateUserName(newName: trimmedname)
        } catch {
            await MainActor.run {
                self.errormeessage = error.localizedDescription
            }
            throw error
        }
    }

    func sendPasswordReset() async throws {
        await MainActor.run {
            self.isLoading = true
        }

        defer {
            Task {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
        do {
            try await authService.sendPasswordReset()
        } catch {
            await MainActor.run {
                self.errormeessage = error.localizedDescription
            }
            throw error
        }
    }

    func logOut() {
        do {
            try authService.signOut()
        } catch {
            errormeessage = "Log Out failed: \(error.localizedDescription)"
        }
    }

    func deleteAccount() async throws {
        await MainActor.run {
            self.isLoading = true
        }

        defer {
            Task {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
        do {
            try await authService.deleteAccount()
        } catch {
            await MainActor.run {
                self.errormeessage = error.localizedDescription
            }
            throw error
        }
    }
}
