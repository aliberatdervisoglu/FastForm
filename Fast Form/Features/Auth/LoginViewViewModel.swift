
import Foundation

@Observable
final class LoginViewViewModel {
    // MARK: - Properties

    @MainActor var email: String = ""
    @MainActor var password: String = ""
    @MainActor var isAuthenticating = false

    private let authService: AuthManager

    // MARK: - Init

    init(authService: AuthManager = AuthManagerImpl()) {
        self.authService = authService
    }

    // MARK: - Public Functions

    @MainActor
    func login() async throws(AuthManagerError) {
        try validate()

        isAuthenticating = true
        defer { isAuthenticating = false }
        do {
            try await authService.signIn(email: email, password: password)
        } catch {
            throw .ivalidEmailOrPassword
        }
    }

    // MARK: - Private Functions

    private func validate() throws(AuthManagerError) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            throw .unknown("Please fill in all the fields!")
        }

        guard email.contains("@"), email.contains(".") else {
            throw .unknown("Please enter a valid email!")
        }
    }
}
