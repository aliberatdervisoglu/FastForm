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
    
    func signIn(email: String, password: String) async throws

    func signUp(name: String, email: String, password: String) async throws

    func observeAuthState(handler: @escaping (String?) -> Void) -> Abortable

    func fetchUserData(userId: String) async throws -> User

    func signOut() throws

    func updateUserName(newName: String) async throws

    func sendPasswordReset() async throws

    func deleteAccount() async throws
}
