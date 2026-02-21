//
//  RegisterView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import SwiftUI

struct RegisterView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    // go back to LoginView
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Image("headerImage")
                .resizable()
                .scaledToFit()
                .padding(.bottom, -80)
            
            Form {
                Section {
                    TextField("Full Name...", text: $fullName)
                        .listRowBackground(Color.white)
                    
                    TextField("Email Address...", text: $email)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .listRowBackground(Color.white)
                    
                    SecureField("Password...", text: $password)
                        .listRowBackground(Color.white)
                    
                    SecureField("Confirm Password...", text: $confirmPassword)
                        .listRowBackground(Color.white)
                }
            }
            .scrollContentBackground(.hidden)
            .frame(height: 260) // Daha fazla alan olduğu için yüksekliği artırdık
            .scrollDisabled(true)
            .foregroundColor(.black)
            .padding(.bottom, -20)
            
            Text("  ") // error
            BigButtonView(title: "Sign Up") {
                print("Kayıt işlemi başlatıldı")
            }
            
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


