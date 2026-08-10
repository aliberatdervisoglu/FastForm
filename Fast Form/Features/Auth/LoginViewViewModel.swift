
import FactoryKit
import Foundation

@MainActor
@Observable
final class LoginViewViewModel {
    // MARK: - Properties

    var email: String = ""
    var password: String = ""
    var isAuthenticating = false

    @ObservationIgnored @Injected(\.authService) private var authService: AuthManager

    // MARK: - Public Functions

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
