//
//  SettingsViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class SettingsViewViewModel: ObservableObject {

    @Published var errormeessage: String? = nil
    @Published var isLoading = false
    @Published var showReauthAlert = false

    init() {
        
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            self.errormeessage = "Log Out failed: \(error.localizedDescription)"
        }
    }
    
    
    func deleteAccount(onSuccess: @escaping () -> Void) {
        guard let currentUser = Auth.auth().currentUser else {return}
        let userID = currentUser.uid
        let db = Firestore.firestore()
        
        self.isLoading = true // for just one touch to butto
        
        db.collection("users").document(userID).delete() { [weak self] error in
            if let error = error {
                self?.handleError(error)
                return
            }
            
            currentUser.delete(){ [weak self] error in
                self?.isLoading = false
                
                if let error = error as NSError? { // type cast for take an ERROR CODE
                    if error.code == AuthErrorCode.requiresRecentLogin.rawValue { // code: 17014
                        self?.showReauthAlert = true
                    } else {
                        self?.handleError(error)
                    }
                } else {
                    onSuccess()
                }
            }
        }
    }
    private func handleError(_ error: Error) {
        self.isLoading = false
        self.errormeessage = error.localizedDescription
    }
}
