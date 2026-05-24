//
//  MainViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation

@Observable
class MainViewViewModel {
    // MARK: - Properties

    var currentUserID: String = ""
    var selectedTabBarItem: Int = 0
    var isLoading = true

    var isSignedIn: Bool {
        authService.isSignedIn
    }

    private var authAbortable: Abortable?
    private let authService: AuthServiceProtocol

    // MARK: - Init

    init(authService: AuthServiceProtocol = AuthManager()) {
        self.authService = authService

        authAbortable = authService.observeAuthState { @MainActor [weak self] uid in
            self?.currentUserID = uid ?? ""
            self?.isLoading = false
        }
    }

    // MARK: - Lifecycle

    deinit {
        authAbortable?.cancel()
    }
}
