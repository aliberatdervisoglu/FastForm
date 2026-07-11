
import Foundation

protocol AuthManager {
    // MARK: - Properties

    var currentUser: User? { get }

    var isSignedIn: Bool { get }

    // MARK: - Public / Internal Functions (Accessible from ViewModels)

    func signIn(email: String, password: String) async throws(AuthManagerError)

    func signUp(name: String, email: String, password: String) async throws(AuthManagerError)

    func observeAuthState(handler: @escaping (String?) -> Void) -> Abortable

    func fetchUserData(userId: String) async throws(AuthManagerError) -> User

    func signOut() throws(AuthManagerError)

    func updateUserName(newName: String) async throws(AuthManagerError)

    func sendPasswordReset() async throws(AuthManagerError)

    func deleteAccount() async throws(AuthManagerError)
}
