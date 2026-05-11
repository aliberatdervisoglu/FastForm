//
//  ProfileViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation
import Combine


class ProfileViewViewModel: ObservableObject {
    @Published var user: User? = nil
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthManager()){
        self.authService = authService
    }
    
    func fetchUser(){
        guard let userId = authService.currentUserID else { return }
        
        
        authService.fetchUserData(userId: userId) { [weak self] result in
            switch result {
            case .success(let fetchedUser):
                DispatchQueue.main.async {
                    self?.user = fetchedUser
                }
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
            }
        }
    }
    func logOut(){
        do {
            try authService.signOut()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
}

