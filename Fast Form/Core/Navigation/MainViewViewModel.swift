//
//  MainViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation

@Observable
class MainViewViewModel {
    var currentUserID: String = ""
    var selectedTabBarItem: Int = 0
    var isLoading = true

    private var authAbortable: Abortable?
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthManager()) {
        self.authService = authService

        authAbortable = authService.observeAuthState { @MainActor [weak self] uid in
            self?.currentUserID = uid ?? ""
            self?.isLoading = false
        }
    }

    var isSignedIn: Bool {
        authService.isSignedIn
    }

    deinit {
        authAbortable?.cancel()
    }
}
