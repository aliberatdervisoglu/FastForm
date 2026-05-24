//
//  ProfileViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation

@Observable
class ProfileViewViewModel {
    // MARK: - Properties

    var user: User?
    var errorMessage: String = ""

    private let authService: AuthServiceProtocol

    // MARK: - Init

    init(authService: AuthServiceProtocol = AuthManager()) {
        self.authService = authService
    }

    // MARK: - Public Functions

    func fetchUser() {
        errorMessage = ""
        guard let userId = authService.currentUser?.id else {
            errorMessage = "Local user ID is missing"
            return
        }
        Task {
            do {
                let fetchedUser = try await authService.fetchUserData(userId: userId)
                await MainActor.run {
                    self.user = fetchedUser
                }
            } catch let error as AuthServiceError {
                await MainActor.run {
                    self.errorMessage = error.errorDescription ?? "Could not load user data. Please try again later."
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = errorMessage.localizedCapitalized
                }
            }
        }
    }

    func logOut() {
        errorMessage = ""
        do {
            try authService.signOut()
        } catch {
            errorMessage = error.errorDescription ?? "Log out failed!"
        }
    }
}
