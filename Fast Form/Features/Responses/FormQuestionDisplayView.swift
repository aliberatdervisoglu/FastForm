//
//  FormQuestionDisplayView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 26.02.2026.
//

import SwiftUI

struct FormQuestionDisplayView: View {
    @State var isEditingQuestion: Bool = false
    @Binding var question: Question
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(question.title)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white)
                    .lineLimit(2)
                Text("Type: " + question.type.rawValue.capitalized)
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundStyle(.white.opacity(0.8))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.title.bold())
                .foregroundStyle(.white.opacity(0.5))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient.brandGradient)
        )
        .padding(.horizontal)
    }
}

#Preview {
    FormQuestionDisplayView(question: .constant(Question(
        id: "preview_q_1",
        title: "En sevdiğin programlama dili hangisi?",
        type: .paragraph,
        isRequired: true,
        options: []
    )))
}
