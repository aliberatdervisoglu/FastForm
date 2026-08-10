
import FactoryKit
import Foundation

@MainActor
@Observable
final class ProfileViewViewModel {
    // MARK: - Properties

    var user: User?

    @ObservationIgnored @Injected(\.authService) private var authService: AuthManager

    // MARK: - Public Functions

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

    func logOut() throws(AuthManagerError) {
        try authService.signOut()
    }
}
