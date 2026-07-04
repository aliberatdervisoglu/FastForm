//
//  MainViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation
import SwiftUI

@MainActor
@Observable
class MainViewViewModel {
    // MARK: - Properties

    var currentUserID: String = ""
    var selectedTabBarItem: Int = 0
    var isLoading = true

    nonisolated private var authAbortable: Abortable?
    private let authService: AuthServiceProtocol

    // MARK: - Init

    init(authService: AuthServiceProtocol? = nil) {
        self.authService = authService ?? AuthManager()

        authAbortable = self.authService.observeAuthState { [weak self] uid in
            Task {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                    self?.currentUserID = uid ?? ""
                    self?.isLoading = false
                }
            }
        }
    }

    // MARK: - Lifecycle

    deinit {
        let abortable = authAbortable
        Task { @MainActor in
            abortable?.cancel()
        }
    }
}
