//
//  LogInView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = "kmkm"
    @State private var password: String = "knkm"
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 25){
                Image("headerImage")
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, -40)
                    
                Form{
                    TextField("Email Address..", text: $email)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .listRowBackground(Color.white)
                    SecureField("Password...", text: $password)
                        .listRowBackground(Color.white)
                }
                .scrollContentBackground(.hidden)
                .frame(height: 150)
                .scrollDisabled(true)
                .foregroundColor(.black)
                
                Text("  ") // Error part will be update
                BigButtonView(title: "Log In"){
                    print("edildi")
                }
                Spacer()
                VStack(spacing: 5){
                    Text("Are you new here?")
                        .foregroundColor(.secondary)
                    NavigationLink("Sign Up",destination: RegisterView())
                        .foregroundStyle(LinearGradient.brandGradient)
                        .font(Font.system(size: 20, weight: .bold, design: .default))
                }
                .padding(.bottom,40)

            }
            .background(Color.white)
        }
    }
}

#Preview {
    LoginView()
}

