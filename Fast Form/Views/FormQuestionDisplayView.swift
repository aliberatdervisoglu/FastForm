//
//  FormQuestionDisplayView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 26.02.2026.
//

import SwiftUI

struct FormQuestionDisplayView: View {
    var question: Question
    var body: some View {
        VStack(alignment: .leading,spacing: 5) {
            Text(question.title)
                .font(.headline)
                .foregroundColor(.primary)
            if question.isRequired {
                Text("*")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    FormQuestionDisplayView(question: Question(title: "çascxac", type: QuestionType.paragraph, isRequired: true))
}
