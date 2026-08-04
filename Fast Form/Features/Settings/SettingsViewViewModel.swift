
import Foundation

@MainActor
@Observable
final class SettingsViewViewModel {
    // MARK: - Properties

    var isLoading = false
    var showReauthAlert = false

    private let authService: AuthManager

    // MARK: - Init

    init(authService: AuthManager) {
        self.authService = authService
    }

    // MARK: - Public Functions

    func updateName(newName: String) async throws(AuthManagerError) {
        let trimmedname = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedname.isEmpty else {
            throw AuthManagerError.unknown("Name field is empty.")
        }
        isLoading = true

        defer {
            self.isLoading = false
        }

        do {
            try await authService.updateUserName(newName: trimmedname)
        } catch {
            throw error
        }
    }

    func sendPasswordReset() async throws(AuthManagerError) {
        isLoading = true

        defer {
            self.isLoading = false
        }
        do {
            try await authService.sendPasswordReset()
        } catch {
            throw error
        }
    }

    func logOut() throws(AuthManagerError) {
        isLoading = true
        try authService.signOut()
    }

    func deleteAccount() async throws(AuthManagerError) {
        isLoading = true

        defer {
            self.isLoading = false
        }
        do {
            try await authService.deleteAccount()
        } catch {
            if error == AuthManagerError.requiresRecentLogin {
                showReauthAlert = true
            }
            throw error
        }
    }
}
