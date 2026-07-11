
import SwiftUI

struct ResponseDetailView: View {
    let form: FormModel
    let response: FormResponse

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(form.title)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(form.explanation)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "calendar")
                            Text("Submitted on \(response.submittedDate.formatted(date: .abbreviated, time: .shortened))")
                        }

                        if let info = response.info {
                            Spacer()
                            HStack {
                                Image(systemName: "person.circle.fill")
                                Text(info.email)
                            }
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)

                    Divider().padding(.top, 8)
                }
                .padding(.horizontal, 4)

                VStack(spacing: 20) {
                    ForEach(form.questionList) { question in
                        VStack(alignment: .leading, spacing: 16) {
                            Text(question.title)
                                .font(.headline)
                                .foregroundStyle(.primary)

                            Group {
                                if let answer = response.answers[question.id] {
                                    displayDisabledAnswer(for: question, answer: answer)
                                } else {
                                    Text("No answer provided")
                                        .italic()
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(uiColor: .systemBackground))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(LinearGradient.brandGradient, lineWidth: 2)
                        )
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(uiColor: .systemGroupedBackground))
    }

    @ViewBuilder
    private func displayDisabledAnswer(for question: Question, answer: Answer) -> some View {
        switch question.type {
        case .shortAnswer, .paragraph:
            Text(answer.value ?? "-")
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(8)
                .foregroundStyle(.primary)

        case .dropdown, .multipleChoice:
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(LinearGradient.brandGradient)
                Text(answer.value ?? "-")
                    .fontWeight(.medium)
            }

        case .checkboxes:
            VStack(alignment: .leading, spacing: 8) {
                ForEach(answer.selections ?? [], id: \.self) { selection in
                    HStack {
                        Image(systemName: "checkmark.square.fill")
                            .foregroundStyle(LinearGradient.brandGradient)
                        Text(selection)
                    }
                    .padding(.horizontal, 8)
                }
            }

        case .toggle:
            HStack {
                Toggle("", isOn: .constant(answer.booleanValue ?? false))
                    .tint(LinearGradient.brandGradient)
                    .labelsHidden()
                    .disabled(true)
            }
        }
    }
}

#Preview {
    let q1Id = "q1"
    let q2Id = "q2"
    let q3Id = "q3"

    let mockQuestions = [
        Question(id: q1Id, title: "How was your experience?", type: .shortAnswer, isRequired: true, options: []),
        Question(id: q2Id, title: "Which features did you use?", type: .checkboxes, isRequired: false, options: ["Mobile App", "Web Portal", "API"]),
        Question(id: q3Id, title: "Do you recommend us?", type: .toggle, isRequired: true, options: []),
    ]

    let mockAnswers: [String: Answer] = [
        q1Id: Answer(questionId: q1Id, value: "It was absolutely amazing!", selections: nil, booleanValue: nil),
        q2Id: Answer(questionId: q2Id, value: nil, selections: ["Mobile App", "API"], booleanValue: nil),
        q3Id: Answer(questionId: q3Id, value: nil, selections: nil, booleanValue: true),
    ]

    let mockForm = FormModel(
        title: "Customer Satisfaction Survey",
        ownerId: "ali123",
        explanation: "Thank you for participating in our 2026 survey.",
        questionList: mockQuestions,
        createDate: Date().timeIntervalSince1970,
        isAnonymus: false
    )

    let mockResponse = FormResponse(
        formId: "form123",
        answers: mockAnswers,
        submittedDate: Date()
    )

    NavigationStack {
        ResponseDetailView(form: mockForm, response: mockResponse)
    }
}
