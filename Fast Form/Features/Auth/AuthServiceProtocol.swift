//
//  AuthServiceProtocol.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 11.05.2026.
//

import Foundation

protocol AuthServiceProtocol {
    // MARK: - Properties

    var currentUser: User? { get }

    var isSignedIn: Bool { get }

    // MARK: - Public / Internal Functions (Accessible from ViewModels)

    func signIn(email: String, password: String) async throws(AuthServiceError)

    func signUp(name: String, email: String, password: String) async throws(AuthServiceError)

    func observeAuthState(handler: @escaping (String?) -> Void) -> Abortable

    func fetchUserData(userId: String) async throws(AuthServiceError) -> User

    func signOut() throws(AuthServiceError)

    func updateUserName(newName: String) async throws(AuthServiceError)

    func sendPasswordReset() async throws(AuthServiceError)

    func deleteAccount() async throws(AuthServiceError)
}
