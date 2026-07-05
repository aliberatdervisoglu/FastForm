
import FirebaseAuth
import FirebaseFirestore
import Foundation

final class AuthManagerImpl: AuthManager {
    // MARK: - Properties

    private let db = Firestore.firestore()

    @MainActor var currentUser: User? {
        guard let firebaseUser = Auth.auth().currentUser else {
            return nil
        }

        return User(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? "",
            email: firebaseUser.email ?? "",
            joined: 0 // it is not needed here
        )
    }

    @MainActor var isSignedIn: Bool {
        Auth.auth().currentUser != nil
    }

    // MARK: - Public / Internal Functions (Accessible from ViewModels)

    func signIn(email: String, password: String) async throws(AuthManagerError) {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            let authError = error as NSError

            if authError.code == AuthErrorCode.wrongPassword.rawValue || authError.code == AuthErrorCode.userNotFound.rawValue {
                throw .ivalidEmailOrPassword
            } else {
                throw .unknown(error.localizedDescription)
            }
        }
    }

    func signUp(name: String, email: String, password: String) async throws(AuthManagerError) {
        var authResult: AuthDataResult

        do {
            authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            let authError = error as NSError

            if authError.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                throw .emailAlreadyInUse
            } else if authError.code == AuthErrorCode.weakPassword.rawValue {
                throw .weakPassword
            } else {
                throw .unknown(error.localizedDescription)
            }
        }

        let userID = authResult.user.uid

        let newUser = User(
            id: userID,
            name: name,
            email: email,
            joined: Date().timeIntervalSince1970
        )

        do {
            try await saveUserData(user: newUser)
        } catch let dbError {
            do {
                try await authResult.user.delete()
                throw AuthManagerError.databaseError(dbError.localizedDescription)
            } catch let cleanupError {
                throw AuthManagerError.unknown("Critical: Firestore save failed (\(dbError.localizedDescription)), and user deletion also failed: \(cleanupError.localizedDescription)")
            }
        }
    }

    @MainActor
    func signOut() throws(AuthManagerError) {
        do {
            try Auth.auth().signOut()
        } catch {
            throw .unknown("Sign out failed:\(error.localizedDescription)")
        }
    }

    /// ***** Should I use AsynStream instead of this closures
    func observeAuthState(handler: @escaping (String?) -> Void) -> Abortable {
        let listener = Auth.auth().addStateDidChangeListener { _, user in
            handler(user?.uid)
        }
        return AnyAbortable { [listener] in
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }

    func fetchUserData(userId: String) async throws(AuthManagerError) -> User {
        let snapshot: DocumentSnapshot
        do {
            snapshot = try await db.collection("users").document(userId).getDocument()
        } catch {
            throw .databaseError(error.localizedDescription)
        }
        guard let userData = snapshot.data() else {
            throw .userNotFound
        }

        return User(
            id: userData["id"] as? String ?? "",
            name: userData["name"] as? String ?? "",
            email: userData["email"] as? String ?? "",
            joined: userData["joined"] as? TimeInterval ?? 0
        )
    }

    func updateUserName(newName: String) async throws(AuthManagerError) {
        guard let userID = currentUser?.id else {
            throw .userNotFound
        }
        do {
            try await db.collection("users").document(userID).updateData(["name": newName])
        } catch {
            throw .databaseError("Name update failed: \(error.localizedDescription)")
        }
    }

    func sendPasswordReset() async throws(AuthManagerError) {
        guard let email = currentUser?.email else {
            throw .userNotFound
        }
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            let authError = error as NSError
            if authError.code == AuthErrorCode.invalidEmail.rawValue {
                throw .unknown("The email address format is invalid.")
            } else {
                throw .unknown(error.localizedDescription)
            }
        }
    }

    func deleteAccount() async throws(AuthManagerError) {
        guard let authCurrentUser = Auth.auth().currentUser else {
            throw .userNotFound
        }
        let userID = authCurrentUser.uid

        do {
            try await db.collection("users").document(userID).delete()
        } catch {
            throw .databaseError(error.localizedDescription)
        }

        do {
            try await authCurrentUser.delete()
        } catch {
            let authError = error as NSError

            if authError.code == AuthErrorCode.requiresRecentLogin.rawValue {
                throw .requiresRecentLogin
            } else {
                throw .unknown(error.localizedDescription)
            }
        }
    }

    // MARK: - Private Functions

    private func saveUserData(user: User) async throws {
        try await db.collection("users")
            .document(user.id)
            .setData(user.asDictionary())
    }
}
