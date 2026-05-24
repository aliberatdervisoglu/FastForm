//
//  AuthManager.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 11.05.2026.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class AuthManager: AuthServiceProtocol {
    // MARK: - Properties

    private let db = Firestore.firestore()

    var currentUser: User? {
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

    var isSignedIn: Bool {
        Auth.auth().currentUser != nil
    }

    // MARK: - Public / Internal Functions (Accessible from ViewModels)

    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func signUp(name: String, email: String, password: String) async throws {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let userID = authResult.user.uid

        let newUser = User(
            id: userID,
            name: name,
            email: email,
            joined: Date().timeIntervalSince1970
        )
        try await saveUserData(user: newUser)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    /// ***** Should I use AsynStream instead of this closures
    func observeAuthState(handler: @escaping (String?) -> Void) -> Abortable {
        let listener = Auth.auth().addStateDidChangeListener { _, user in
            handler(user?.uid)
        }
        return AnyAbortable {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }

    func fetchUserData(userId: String) async throws -> User {
        let snapshot = try await db.collection("users").document(userId).getDocument()

        guard let data = snapshot.data() else {
            throw NSError(
                domain: "AuthManager",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "User Not Found"]
            )
        }

        return User(
            id: data["id"] as? String ?? "",
            name: data["name"] as? String ?? "",
            email: data["email"] as? String ?? "",
            joined: data["joined"] as? TimeInterval ?? 0
        )
    }

    func updateUserName(newName: String) async throws {
        guard let userID = currentUser?.id else {
            throw NSError(
                domain: "AuthManager",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Current user not found"]
            )
        }
        try await db.collection("users").document(userID).updateData(["name": newName])
    }

    func sendPasswordReset() async throws {
        guard let email = currentUser?.email else {
            throw NSError(
                domain: "AuthManager",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "User email is missing or unavailble"]
            )
        }
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

    func deleteAccount() async throws {
        guard let authCurrentUser = Auth.auth().currentUser else {
            throw NSError(
                domain: "AuthManager",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "No authenticated user to delete account for"]
            )
        }
        let userID = authCurrentUser.uid

        try await db.collection("users").document(userID).delete()

        do {
            try await authCurrentUser.delete()
        } catch {
            let authError = error as NSError

            if authError.code == AuthErrorCode.requiresRecentLogin.rawValue {
                throw NSError(
                    domain: "AuthManager",
                    code: authError.code,
                    userInfo: [NSLocalizedDescriptionKey: "This operation is sensitive and requires recent authentication. Log in again before retrying."]
                )
            } else {
                throw error
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
