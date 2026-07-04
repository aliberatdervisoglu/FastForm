
import Foundation
import SwiftUI

@MainActor
@Observable
final class MainViewViewModel {
    // MARK: - Properties

    var currentUserID: String = ""
    var selectedTabBarItem: Int = 0
    var isLoading = true

    nonisolated private var authAbortable: Abortable?
    private let authService: AuthManager

    // MARK: - Init

    init(authService: AuthManager? = nil) {
        self.authService = authService ?? AuthManagerImpl()

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
