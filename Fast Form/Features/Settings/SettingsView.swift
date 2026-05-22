//
//  SettingsView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//
//  profile kısmından erişim

import SwiftUI

struct SettingsView: View {
    @State var viewModel = SettingsViewViewModel()
    
    @State private var showDeleteConfirmation: Bool = false
    @State private var logOutConfirmation: Bool = false
    @State private var showChangeName: Bool = false
    @State private var newName = ""
    @State private var showPasswordChange: Bool = false
    

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
                            showChangeName = true
                        }
                        Divider()

                        setRawView(title: "Set Password", iconname: "lock") {
                            viewModel.sendPasswordReset { success in
                                    if success {
                                        showPasswordChange = true
                                    }
                                }
                        }
                        Divider()
                        setRawView(title: "Log Out", iconname: "rectangle.portrait.and.arrow.right", optionalColor: .blue) {
                            logOutConfirmation = true
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
                    Spacer()

                }
                .padding(.top, 22)
                
            }
            .navigationTitle("Settings")
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
            .alert("Check Your Email", isPresented: $showPasswordChange){
                Button("OK", role: .cancel) { }
            } message: {
                Text("We've sent a password reset link to your email address. Please check your inbox and follow the instructions.")
            }
            .alert("Security Re-Authentication", isPresented: $viewModel.showReauthAlert) {
                Button("Log Out & In Again") {
                    viewModel.logOut()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("For your security, you must have logged in recently to delete your account. Please log out and log back in, then try again.")
            }
            .sheet(isPresented: $showChangeName) {
                NavigationStack {
                    VStack(spacing: 20){
                        Text("Update your name: ")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.primary)
                            .padding(.top)
                        TextField("New Name", text: $newName)
                            .padding()
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.black.opacity(0.8))
                            .background(RoundedRectangle(cornerRadius: 15).fill(.gray.opacity(0.3)))
                            .padding()
                        Spacer()
                    }
                    .padding()
                    .navigationTitle("Edit Name")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                viewModel.updateName(newName: newName) { success in
                                    if success {
                                        showChangeName = false
                                        newName = ""
                                    }
                                }
                                
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(Color(.green))
                            }
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                showChangeName = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(Color(.red))
                            }
                        }
                    }
                    .presentationDetents([.fraction(0.4)])
                    .presentationDragIndicator(.visible)
                }
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
                        .frame(width: 32, height: 32)
                        .foregroundStyle(Color("BrandGradientEnd").opacity(0.1))
                    
                    Image(systemName: iconname)
                        .foregroundStyle(Color("BrandGradientEnd"))
                        .font(.system(size: 14))
                }
                Text(title)
                    .font(.body)
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
