
import Foundation

@Observable
final class SettingsViewViewModel {
    // MARK: - Properties

    @MainActor var isLoading = false
    @MainActor var showReauthAlert = false

    private let authService: AuthManager

    // MARK: - Init

    init(authService: AuthManager = AuthManagerImpl()) {
        self.authService = authService
    }

    // MARK: - Public Functions

    @MainActor
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

    @MainActor
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

    @MainActor
    func logOut() throws(AuthManagerError) {
        isLoading = true
        try authService.signOut()
    }

    @MainActor
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
