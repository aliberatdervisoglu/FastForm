//
//  FormBuilderView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import SwiftUI
import FirebaseAuth

struct FormBuilderView: View {
    var body: some View {
        VStack{
            Text("FORM BUILDER VIEW")

            Button {
                do {
                    try Auth.auth().signOut()
                    print("Başarıyla çıkış yapıldı")
                } catch {
                    print("Çıkış yaparken bir hata oluştu")
                }
            } label: {
                Text("Güvenli Çıkış Yap")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

#Preview {
    FormBuilderView()
}
