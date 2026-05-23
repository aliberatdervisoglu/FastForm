//
//  AuthServiceProtocol.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 11.05.2026.
//

import Foundation

protocol AuthServiceProtocol {
    /// Giriş yapma fonksiyonu
    func signIn(email: String, password: String) async throws

    /// Kayıt olma ve kullanıcıyı Firestore'a kaydetme fonksiyonu
    func signUp(name: String, email: String, password: String) async throws

    /// Mevcut kullanıcı ID'sini döndürür
    var currentUser: User? { get }

    func observeAuthState(handler: @escaping (String?) -> Void) -> Abortable

    func fetchUserData(userId: String) async throws -> User

    func signOut() throws

    func updateUserName(newName: String) async throws

    func sendPasswordReset() async throws

    func deleteAccount() async throws
    var isSignedIn: Bool { get }
}
