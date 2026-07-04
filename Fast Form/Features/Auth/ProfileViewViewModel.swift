
import Foundation

@Observable
class ProfileViewViewModel {
    // MARK: - Properties

    @MainActor var user: User?

    private let authService: AuthManager

    // MARK: - Init

    init(authService: AuthManager = AuthManagerImpl()) {
        self.authService = authService
    }

    // MARK: - Public Functions

    @MainActor
    func fetchUser() async throws(AuthManagerError) {
        guard let userId = authService.currentUser?.id else {
            throw AuthManagerError.unknown("Local user ID is missing")
        }
        do {
            user = try await authService.fetchUserData(userId: userId)
        } catch {
            throw error
        }
    }

    @MainActor
    func logOut() throws(AuthManagerError) {
        try authService.signOut()
    }
}
