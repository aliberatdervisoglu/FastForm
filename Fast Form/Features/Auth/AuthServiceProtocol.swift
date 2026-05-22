//
//  AuthServiceProtocol.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 11.05.2026.
//

import Foundation

protocol AuthServiceProtocol {
    // Giriş yapma fonksiyonu
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    // Kayıt olma ve kullanıcıyı Firestore'a kaydetme fonksiyonu
    func signUp(name: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    // Mevcut kullanıcı ID'sini döndürür
    var currentUserID: String? { get }
    
    func observeAuthState(handler: @escaping (String?) -> Void)
    
    func fetchUserData(userId: String, completion: @escaping (Result<User, Error>) -> Void)
    
    func signOut() throws
    
    var currentUserEmail: String? { get }
    
    func updateUserName(newName: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func sendPasswordReset(completion: @escaping (Result<Void, Error>) -> Void)
    
    func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void)
    
    var isSignedIn: Bool { get }
}
