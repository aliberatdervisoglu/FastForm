//
//  LoginView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel = LoginViewViewModel()

    @State private var localErrorMessage: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                VStack(spacing: 25) {
                    Image("headerImage")
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom, -40)

                    Form {
                        TextField("Email Address..", text: $viewModel.email)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .listRowBackground(Color.white)
                        SecureField("Password...", text: $viewModel.password)
                            .listRowBackground(Color.white)
                    }
                    .scrollContentBackground(.hidden)
                    .frame(height: 150)
                    .scrollDisabled(true)
                    .foregroundColor(.black)

                    VStack {
                        if !localErrorMessage.isEmpty {
                            ErrorBannerView(message: localErrorMessage)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                                .id(localErrorMessage)
                        }
                    }
                    .frame(height: 60)
                    .padding(.horizontal, 20)
                    .animation(.spring(response: 0.4, dampingFraction: 0.75), value: localErrorMessage)

                    BigButtonView(title: "Log In") {
                        Task { @MainActor in
                            withAnimation(.easeInOut(duration: 0.25)) {
                                localErrorMessage = ""
                            }

                            do {
                                try await viewModel.login()
                            } catch let lerror as AuthServiceError {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    localErrorMessage = lerror.errorDescription ?? "An unexpected error occurred."
                                }
                            } catch {
                                withAnimation(.easeInOut(duration: 0.25)) {
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
                        Text("Are you new here?")
                            .foregroundColor(.secondary)
                        NavigationLink("Sign Up", destination: RegisterView())
                            .foregroundStyle(LinearGradient.brandGradient)
                            .font(Font.system(size: 20, weight: .bold, design: .default))
                    }
                    .padding(.bottom, 40)
                }
                .background(Color.white)
            }
        }
    }
}

#Preview {
    LoginView()
}
