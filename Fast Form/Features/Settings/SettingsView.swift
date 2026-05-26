//
//  SettingsView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import SwiftUI

struct SettingsView: View {
    @State var viewModel = SettingsViewViewModel()

    @State private var showDeleteConfirmation: Bool = false
    @State private var logOutConfirmation: Bool = false
    @State private var showChangeName: Bool = false
    @State private var newName = ""
    @State private var showPasswordChange: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
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

                    VStack(spacing: 20) {
                        setRawView(title: "Set Name", iconname: "person") {
                            showChangeName = true
                        }
                        Divider()

                        setRawView(title: "Set Password", iconname: "lock") {
                            Task {
                                do {
                                    try await viewModel.sendPasswordReset()
                                    await MainActor.run { showPasswordChange = true }
                                } catch {
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
                        }
                        .alert("Check Your Email", isPresented: $showPasswordChange) {
                            Button("OK", role: .cancel) {}
                        } message: {
                            Text("We've sent a password reset link to your email address.")
                        }
                        Divider()

                        setRawView(title: "Log Out", iconname: "rectangle.portrait.and.arrow.right", optionalColor: .blue) {
                            logOutConfirmation = true
                        }
                        .alert("You are logging out...", isPresented: $logOutConfirmation) {
                            Button("Log Out", role: .destructive) {
                                try? viewModel.logOut() // logOut is sync based on your VM
                            }
                            Button("Cancel", role: .cancel) {}
                        } message: {
                            Text("Are you sure you want to log out?")
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
            .alert("Are you absolutely sure", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    Task {
                        try? await viewModel.deleteAccount()
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This action cannot be undone.")
            }
            .alert("Security Re-Authentication", isPresented: $viewModel.showReauthAlert) {
                Button("Log Out & In Again") {
                    try? viewModel.logOut()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please log out and log back in, then try again.")
            }
            .sheet(isPresented: $showChangeName) {
                NavigationStack {
                    VStack(spacing: 20) {
                        TextField("New Name", text: $newName)
                            .padding()
                            .textFieldStyle(.roundedBorder)
                        Spacer()
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Save") {
                                Task {
                                    try? await viewModel.updateName(newName: newName)
                                    showChangeName = false
                                    newName = ""
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func setRawView(title: String, iconname: String, optionalColor: Color? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                ZStack {
                    Circle().frame(width: 32, height: 32).foregroundStyle(Color("BrandGradientEnd").opacity(0.1))
                    Image(systemName: iconname).foregroundStyle(Color("BrandGradientEnd")).font(.system(size: 14))
                }
                Text(title).font(.body).foregroundColor(optionalColor ?? .primary).fontWeight(.semibold)
                Spacer()
            }
        }
    }
}
