//
//  FormResponsesListView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 21.03.2026.
//

import SwiftUI

struct FormResponsesListView: View {
    let form: FormModel
    @State private var viewModel = FormResponsesListViewViewModel()

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    if viewModel.isLoading {
                        ProgressView("Loading responses...")
                            .padding(.top, 40)
                    } else if !viewModel.errorMessage.isEmpty {
                        ContentUnavailableView(
                            "Failed to Load",
                            systemImage: "exclamationmark.triangle.fill",
                            description: Text(viewModel.errorMessage)
                        )
                        .padding(.top, 40)

                    } else if viewModel.responses.isEmpty {
                        ContentUnavailableView("No Responses Yet",
                                               systemImage: "bubble.left.and.right",
                                               description: Text("Once someone fills out the form, it will appear here."))
                            .padding(.top, 40)
                    } else {
                        ForEach(Array(viewModel.responses.enumerated()), id: \.element.id) { index, response in
                            NavigationLink(destination: ResponseDetailView(form: form, response: response)) {
                                responseCard(index: index, response: response)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Responses")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchResponses(ownerId: form.ownerId, formId: form.id)
        }
    }

    private func responseCard(index: Int, response: FormResponse) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                if let email = response.info?.email, !email.isEmpty {
                    Text(email)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                } else {
                    Text("Anonymous Respondent #\(viewModel.responses.count - index)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }

                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                    Text(response.submittedDate.formatted(date: .abbreviated, time: .shortened))
                }
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
            }

            Spacer()

            Image(systemName: "chevron.right.circle.fill")
                .font(.title2)
                .foregroundStyle(.white)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient.brandGradient)
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    let mockQuestions = [
        Question(title: "Deneyiminiz?", type: .shortAnswer, isRequired: true, options: []),
    ]

    let mockForm = FormModel(
        title: "Müşteri Geri Bildirimi",
        ownerId: "ali123",
        explanation: "Hizmet kalitemizi değerlendirin.",
        questionList: mockQuestions,
        createDate: Date().timeIntervalSince1970,
        isAnonymus: false
    )

    return NavigationStack {
        FormResponsesListView(form: mockForm)
    }
}

// #Preview("Anonymous Form") {
//    let mockForm = FormModel(
//        title: "Gizli Oylama",
//        ownerId: "ali123",
//        explanation: "Fikirlerinizi anonim olarak paylaşın.",
//        questionList: [],
//        createDate: Date().timeIntervalSince1970,
//        isAnonymus: true
//    )
//
//    return NavigationStack {
//        FormResponsesListView(form: mockForm)
//    }
// }
