//
//  MainViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation

@Observable
class MainViewViewModel{
    var currentUserID: String = ""
    var selectedTabBarItem: Int = 0
    var isLoading = true
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthManager()){
        self.authService = authService
        
        authService.observeAuthState { [weak self] uid in
            DispatchQueue.main.async {
                self?.currentUserID = uid ?? ""
                self?.isLoading = false
            }
        }
    }
     var isSignedIn: Bool {
        return !currentUserID.isEmpty
    }
}
