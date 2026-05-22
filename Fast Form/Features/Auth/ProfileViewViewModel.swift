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
        guard let userId = authService.currentUserID else { return }

        authService.fetchUserData(userId: userId) { @MainActor [weak self] result in
            switch result {
            case let .success(fetchedUser):
                self?.user = fetchedUser
            case let .failure(error):
                print("Error:\(error.localizedDescription)")
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
