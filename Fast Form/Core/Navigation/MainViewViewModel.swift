//
//  MainViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation
import SwiftUI

@Observable
class MainViewViewModel {
    // MARK: - Properties

    @MainActor var currentUserID: String = ""
    @MainActor var selectedTabBarItem: Int = 0
    @MainActor var isLoading = true

    private var authAbortable: Abortable?
    private let authService: AuthServiceProtocol

    // MARK: - Init

    init(authService: AuthServiceProtocol = AuthManager()) {
        self.authService = authService

        authAbortable = authService.observeAuthState { [weak self] uid in
            Task { @MainActor in
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                    self?.currentUserID = uid ?? ""
                    self?.isLoading = false
                }
            }
        }
    }

    // MARK: - Lifecycle

    deinit {
        authAbortable?.cancel()
    }
}
