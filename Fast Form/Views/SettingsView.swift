//
//  SettingsView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//
//  profile kısmından erişim

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewViewModel()
    
    @State var showDeleteConfirmation: Bool = false
    @State var logOutConfirmation: Bool = false
    

    var body: some View {
        NavigationStack{
            ZStack{
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                VStack(alignment: .center, spacing: 15) {
                    Image(systemName: "gear.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color("BrandGradientEnd"))
                        .frame(width: 125, height: 125)
                        .padding()
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .padding(.bottom, 10)
                    VStack(spacing: 20){
                        setRawView(title: "Set Name", iconname: "person") {
                            print("trial1")
                        }
                        
                        Divider()
                        setRawView(title: "Set Mail", iconname: "at") {
                            print("trial1")
                        }
                        
                        Divider()
                        setRawView(title: "Set Password", iconname: "lock") {
                            print("trial1")
                        }
                        
                        Divider()
                        setRawView(title: "Log Out", iconname: "rectangle.portrait.and.arrow.right", optionalColor: .blue) {
                            print("trial2")
                        }
                        Divider()
                        setRawView(title: "Delete Account", iconname: "person.crop.circle.badge.minus", optionalColor: .red) {
                            showDeleteConfirmation = true
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)

                }
            }
            .alert("You are logging out...", isPresented: $logOutConfirmation) {
                Button("Log Out") {
                    viewModel.logOut()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to log out?")
            }
            .alert("Are you absolutely sure", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    viewModel.deleteAccount {
                    }
                }
                Button("Cancel", role: .cancel){ }
            } message: {
                Text("This action cannot be undone. Are you sure you want to delete your account?")
            }
            .alert("Security Re-Authentication", isPresented: $viewModel.showReauthAlert) {
                Button("Log Out & In Again") {
                    viewModel.logOut()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("For your security, you must have logged in recently to delete your account. Please log out and log back in, then try again.")
            }
        }
    }
    @ViewBuilder
    func setRawView(title: String ,iconname: String,optionalColor: Color? = nil, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack{
                ZStack {
                    Circle()
                        .frame(width: 42, height: 42)
                        .foregroundStyle(Color("BrandGradientEnd").opacity(0.1))
                    
                    Image(systemName: iconname)
                        .foregroundStyle(Color("BrandGradientEnd"))
                        .font(.system(size: 24))
                }
                Text(title)
                    .font(.title3)
                    .foregroundColor(optionalColor ?? .primary)
                    .fontWeight(.semibold)
                Spacer()
            }
        }
    }
}

#Preview {
    SettingsView()
}
