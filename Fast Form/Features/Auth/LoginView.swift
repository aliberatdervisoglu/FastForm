//
//  LogInView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import SwiftUI

struct LoginView: View {
    
    
    @State var viewModel = LoginViewViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                VStack(spacing: 25){
                    Image("headerImage")
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom, -40)
                        
                    Form{
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
                    
                    if !viewModel.errorMessage.isEmpty{
                        Text(viewModel.errorMessage)
                            .foregroundStyle(.red)
                    } else {
                        Text("  ")
                    }
                    
                    BigButtonView(title: "Log In"){
                        viewModel.login()
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
}

#Preview {
    LoginView()
}

