//
//  ProfileView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import SwiftUI

struct ProfileView: View {
    @State var viewModel = ProfileViewViewModel()
    @State private var localErrorMessage: String = ""

    private let userID: String

    init(takenUserID: String) {
        userID = takenUserID
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        if let user = viewModel.user {
                            profile(user: user)

                        } else {
                            ProgressView("Loading Profile...")
                                .padding(.top, 50)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                Task {
                    do {
                        try await viewModel.fetchUser()
                    } catch let error as AuthServiceError {
                        localErrorMessage = error.errorDescription ?? "Failed to load profile."
                    } catch {
                        localErrorMessage = "An unexpected error occurred."
                    }
                }
            }
        }
    }

    @ViewBuilder
    func profile(user: User) -> some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Color("BrandGradientEnd"))
            .frame(width: 125, height: 125)
            .padding()
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
            .padding(.bottom, 10)

        VStack(spacing: 0) {
            profileRow(icon: "person.fill", title: "Name", value: user.name)

            Divider()

            profileRow(icon: "envelope.fill", title: "Email", value: user.email)

            Divider()

            profileRow(icon: "calendar", title: "Joined", value: "\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }

    func profileRow(icon: String, title: String, value: String) -> some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(Color("BrandGradientEnd").opacity(0.1))

                Image(systemName: icon)
                    .foregroundStyle(Color("BrandGradientEnd"))
                    .font(.system(size: 14))
            }

            Text(title)
                .font(.body)
                .foregroundColor(.gray)
                .fontWeight(.medium)

            Spacer()

            Text(value)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding()
    }
}

#Preview {
    ProfileView(takenUserID: "uBTFyEMizhYmsjIZBGYkkRhPNy63")
}
