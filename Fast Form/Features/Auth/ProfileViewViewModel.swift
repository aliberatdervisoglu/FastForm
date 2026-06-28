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

    @MainActor var user: User?

    private let authService: AuthServiceProtocol

    // MARK: - Init

    init(authService: AuthServiceProtocol = AuthManager()) {
        self.authService = authService
    }

    // MARK: - Public Functions

    @MainActor
    func fetchUser() async throws(AuthServiceError) {
        guard let userId = authService.currentUser?.id else {
            throw AuthServiceError.unknown("Local user ID is missing")
        }
        do {
            user = try await authService.fetchUserData(userId: userId)
        } catch {
            throw error
        }
    }

    @MainActor
    func logOut() throws(AuthServiceError) {
        try authService.signOut()
    }
}
