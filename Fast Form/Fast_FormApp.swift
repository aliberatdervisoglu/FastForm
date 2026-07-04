//
//  Fast_FormApp.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import FirebaseCore
import FirebaseFirestore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()
        return true
    }
}

@main
@MainActor
struct FastFormApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State private var mainViewModel: MainViewViewModel
    
    init() {
        let vm = MainViewViewModel()
        _mainViewModel = State(wrappedValue: vm)
    }
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: mainViewModel)
        }
    }
}
