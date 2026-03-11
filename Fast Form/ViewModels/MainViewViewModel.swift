//
//  MainViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import FirebaseAuth
import Foundation
import Combine

class MainViewViewModel: ObservableObject{
    @Published var currentUserID: String = ""
    @Published var selectedTabBarItem: Int = 0
    public var isLoading = true
    
    init(){
        let _ = Auth.auth().addStateDidChangeListener{ [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserID = user?.uid ?? ""
                self?.isLoading = false
            }
        }
    }
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
}
