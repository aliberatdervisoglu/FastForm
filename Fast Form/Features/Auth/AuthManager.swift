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

    

    private let db = Firestore.firestore()

    func signIn(email: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func signUp(name: String, email: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let userID = result?.user.uid else { return }

            self?.saveUserToFirestore(id: userID, name: name, email: email, completion: completion)
        }
    }

    private func saveUserToFirestore(id: String, name: String, email: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        let newUser = User(id: id, name: name, email: email, joined: Date().timeIntervalSince1970)

        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary()) { error in
                if let error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }

    func observeAuthState(handler: @escaping (String?) -> Void) -> Abortable {
        let listener = Auth.auth().addStateDidChangeListener { _, user in
            handler(user?.uid)
        }
        
        return AnyAbortable {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }

    func fetchUserData(userId: String, completion: @escaping (Result<User, any Error>) -> Void) {
        db.collection("users")
            .document(userId)
            .getDocument { snapshot, error in
                if let error {
                    completion(.failure(error))
                    return
                }

                guard let data = snapshot?.data() else {
                    completion(.failure(NSError(domain: "AuthMAnager", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                    return
                }

                let user = User(
                    id: data["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0
                )

                completion(.success(user))
            }
    }

    func updateUserName(newName: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let userID = currentUser?.id else { return }

        db.collection("users")
            .document(userID).updateData(["name": newName]) { error in
                if let error {
                    completion(.failure(NSError(domain: "AuthManager", code: 401, userInfo: [NSLocalizedDescriptionKey : "User ID is missing or user is not authenticated"])))
                } else {
                    completion(.success(()))
                }
            }
    }

    func sendPasswordReset(completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let email = currentUser?.email else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error {
                completion(.failure(NSError(domain: "AuthManager", code: 400, userInfo: [NSLocalizedDescriptionKey : "User email is missing or unavailble"])))
            } else {
                completion(.success(()))
            }
        }
    }

    func deleteAccount(completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let userID = currentUser.uid

        db.collection("users")
            .document(userID).delete { error in
                if let error {
                    completion(.failure(error))
                    return
                }
                currentUser.delete { error in
                    if let error = error as NSError? {
                        if error.code == AuthErrorCode.requiresRecentLogin.rawValue {
                            completion(.failure(AuthServiceError.requiresRecentLogin))
                        } else {
                            completion(.failure(error))
                        }
                    } else {
                        completion(.success(()))
                    }
                }
            }
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    var isSignedIn: Bool {
        Auth.auth().currentUser != nil
    }
    
}
