//
//  MainView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import SwiftUI

struct MainView: View {
    
    @State private var draftForm: FormModel = FormModel(
        id: UUID().uuidString,
        title: "",
        ownerId: "",
        explanation: "",
        questionList: [],
        createDate: Date().timeIntervalSince1970,
        isAnonymus: false
        )
    
    @StateObject var viewModel = MainViewViewModel()
    @State private var selectedTab: Int = 0
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserID.isEmpty{
            mainTabView
        } else {
            LoginView()
        }
    }
    @ViewBuilder
    var mainTabView: some View {
        TabView(selection: $selectedTab){
            
            FormListView(userId: viewModel.currentUserID)
                .tabItem({
                    Label("Form List", systemImage: "list.dash")
                })
                .tag(0)
            ResponseFormView()
                .tabItem({
                    Label("Responses", systemImage: "list.bullet.clipboard")
                })
                .tag(1)
            FormBuilderView(formToEdit: draftForm, tabselection: $selectedTab)
                .tabItem({
                    Label("Form Builder", systemImage: "clipboard")
                })
                .tag(2)
            ProfileView(takenUserID: "uBTFyEMizhYmsjIZBGYkkRhPNy63")
                .tabItem({
                    Label("Profile" , systemImage: "person.crop.circle")
                })
                .tag(3)
            SettingsView()
                .tabItem({
                    Label("Settings" , systemImage: "gearshape.fill")
                })
                .tag(4)
        }
        .tint(Color("BrandGradientStart"))
    }
    
    
}

#Preview {
    MainView()
}


//TabView{
//    FormBuilderView()
//        .tabItem({
//            Label("Form Builder", systemImage: "clipboard")
//        })
//    ResponseFormView()
//        .tabItem({
//            Label("Responses", systemImage: "list.bullet.clipboard")
//        })
//    ProfileView()
//        .tabItem({
//            Label("Profile" , systemImage: "person.crop.circle")
//        })
//    SettingsView()
//        .tabItem({
//            Label("Settings" , systemImage: "gearshape.fill")
//        })
//}
//.tint(Color("BrandGradientStart"))
