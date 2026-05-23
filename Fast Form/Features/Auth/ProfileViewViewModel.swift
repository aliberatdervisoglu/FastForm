//
//  ProfileViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation

@Observable
class ProfileViewViewModel {
    var user: User?

    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthManager()) {
        self.authService = authService
    }

    func fetchUser() {
        guard let userId = authService.currentUser?.id else {
            print("Error: Local user ID is missing")
            return
        }
        Task {
            do {
                let user = try await authService.fetchUserData(userId: userId)
                await MainActor.run {
                    self.user = user
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func logOut() {
        do {
            try authService.signOut()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
