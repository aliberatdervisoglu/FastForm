//
//  RegisterView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import SwiftUI

struct RegisterView: View {
    @State var viewModel = RegisterViewViewModel()
    @State private var localErrorMessage: String = ""

    /// go back to LoginView
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Image("headerImage")
                .resizable()
                .scaledToFit()
                .padding(.bottom, -80)

            Form {
                Section {
                    TextField("Full Name...", text: $viewModel.name)
                        .listRowBackground(Color.white)

                    TextField("Email Address...", text: $viewModel.email)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .listRowBackground(Color.white)

                    SecureField("Password...", text: $viewModel.password)
                        .listRowBackground(Color.white)

                    SecureField("Confirm Password...", text: $viewModel.confirmPassword)
                        .listRowBackground(Color.white)
                }
            }
            .scrollContentBackground(.hidden)
            .frame(height: 260) // Daha fazla alan olduğu için yüksekliği artırdık
            .scrollDisabled(true)
            .foregroundColor(.black)
            .padding(.bottom, -20)

            VStack {
                if !localErrorMessage.isEmpty {
                    ErrorBannerView(message: localErrorMessage)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                        .id(localErrorMessage)
                }
            }
            .frame(height: 40)
            .padding(.horizontal, 20)
            .animation(.spring(response: 0.4, dampingFraction: 0.75), value: localErrorMessage)

            BigButtonView(title: "Sign Up") {
                Task {
                    withAnimation { localErrorMessage = "" }
                    do {
                        try await viewModel.register()
                    } catch let lerror as AuthManagerError {
                        withAnimation {
                            localErrorMessage = lerror.errorDescription ?? "Registration failed."
                        }
                    } catch {
                        withAnimation {
                            localErrorMessage = error.localizedDescription
                        }
                    }
                }
            }
            .overlay {
                if viewModel.isAuthenticating {
                    ProgressView()
                        .tint(.white)
                }
            }
            .disabled(viewModel.isAuthenticating)

            Spacer()

            VStack(spacing: 5) {
                Text("Already have an account?")
                    .foregroundColor(.secondary)
                Button(action: {
                    dismiss() // back to login
                }) {
                    Text("Log In")
                        .fontWeight(.bold)
                        .foregroundStyle(LinearGradient.brandGradient)
                        .font(.system(size: 20, weight: .bold))
                }
            }
            .padding(.bottom, 40)
        }
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    RegisterView()
}
