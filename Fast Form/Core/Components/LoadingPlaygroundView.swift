//
//  LoadingPlaygroundView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 11.03.2026.
//

import SwiftUI

struct LoadingPlaygroundView: View {
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Ortak Arka Planımız
            LinearGradient.brandGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Image(systemName: "bolt.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.white)
                    .scaleEffect(isAnimating ? 1.1 : 0.9) //
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
                
                HStack{
                    Text("Fast Form Loading...")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white.opacity(0.8))
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                }
            }
        }
        .onAppear {
            // Animasyonları tetiklemek için
            isAnimating = true
        }
    }
    


}

#Preview {
    LoadingPlaygroundView()
}
