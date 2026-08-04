
import Foundation
import SwiftUI

@MainActor
@Observable
final class MainViewViewModel {
    // MARK: - Properties

    var currentUserID: String = ""
    var selectedTabBarItem: Int = 0
    var isLoading = true

    private var authTask: Task<Void, Never>?
    private let authService: AuthManager

    // MARK: - Init

    init(authService: AuthManager) {
        self.authService = authService

        listenToAuthState()
    }

    // MARK: - Private Functions

    private func listenToAuthState() {
        authTask?.cancel()
        authTask = Task {
            for await uid in authService.observeAuthState() {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                    self.currentUserID = uid ?? ""
                    self.isLoading = false
                }
            }
        }
    }

    func cancelListening() {
        authTask?.cancel()
        authTask = nil
    }
}
