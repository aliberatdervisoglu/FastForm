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
                            HStack(spacing: 10) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)

                                Text(localErrorMessage)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.leading)

                                Spacer()
                            }
                            .padding()
                            .background(Color.red.opacity(0.1)) // Subtle tint background
                            .cornerRadius(10)
                            .transition(.opacity.combined(with: .move(edge: .top))) // Smooth drop-down transition
                        }
                    }
                    .frame(height: 60) // 🎯 Locks the vertical space completely to eliminate layout jumps!
                    .padding(.horizontal, 20)

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
