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

    @MainActor var currentUserID: String = ""
    @MainActor var selectedTabBarItem: Int = 0
    @MainActor var isLoading = true

    @MainActor
    var isSignedIn: Bool {
        authService.isSignedIn
    }

    private var authAbortable: Abortable?
    private let authService: AuthServiceProtocol

    // MARK: - Init

    init(authService: AuthServiceProtocol = AuthManager()) {
        self.authService = authService

        authAbortable = authService.observeAuthState { [weak self] uid in
            guard let self else { return }
            currentUserID = uid ?? ""
            isLoading = false
        }
    }

    // MARK: - Lifecycle

    deinit {
        authAbortable?.cancel()
    }
}
