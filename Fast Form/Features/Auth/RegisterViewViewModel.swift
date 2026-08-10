
import FactoryKit
import Foundation

@MainActor
@Observable
final class RegisterViewViewModel {
    // MARK: - Properties

    var name: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""

    var isAuthenticating = false

    @ObservationIgnored @Injected(\.authService) private var authService: AuthManager

    // MARK: - Public Functions

    func register() async throws(AuthManagerError) {
        try validate()

        isAuthenticating = true
        defer { isAuthenticating = false }
        do {
            try await authService.signUp(name: name, email: email, password: password)
        } catch {
            throw error
        }
    }

    // MARK: - Private Functions

    private func validate() throws(AuthManagerError) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !confirmPassword.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            throw .unknown("Please fill in all the fields")
        }
        guard password == confirmPassword else {
            throw .unknown("Passwords do not match")
        }
        guard email.contains("@"), email.contains(".") else {
            throw .unknown("Please enter a valid email")
        }
        guard password.count >= 6 else {
            throw .unknown("Password must be at least 6 characters long")
        }
    }
}
