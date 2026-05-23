import SwiftUI

struct ResponseChoosenFormView: View {
    let form: FormModel

    @State private var viewModel = ResponseChoosenFormViewViewModel()
    @State private var userAnswers: [String: Answer] = [:]
    @State private var errorQuestionId: String? = nil

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(alignment: .leading, spacing: 24) {
                        headerSection
                        Divider()
                        VStack(spacing: 20) {
                            ForEach(form.questionList) { question in
                                questionCard(for: question)
                                    .id(question.id) // we are giving this card that their questions id because to swipe if there are a problem
                            }
                        }
                        BigButtonView(title: "Send Form") {
                            if let errorId = viewModel.validateAnswers(form: form, answers: userAnswers) {
                                errorQuestionId = errorId
                                withAnimation(.spring()) {
                                    proxy.scrollTo(errorId, anchor: .center)
                                }
                            } else {
                                errorQuestionId = nil
                                submitForm()
                            }
                        }
                    }
                    .padding()
                    .onChange(of: errorQuestionId) { _, newValue in
                        if let idToScroll = newValue {
                            withAnimation(.spring()) {
                                proxy.scrollTo(idToScroll, anchor: .center)
                            }
                        }
                    }
                }
            }
            .alert("Alert", isPresented: $viewModel.showAlert) {
                Button("Okey", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error!")
            }
            .overlay {
                if viewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.4).ignoresSafeArea()
                        ProgressView("Sending...")
                            .padding()
                            .background(Color(uiColor: .systemBackground))
                            .cornerRadius(10)
                    }
                }
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Fill form")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(form.title)
                .font(.title)
                .fontWeight(.bold)

            Text(form.explanation)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if form.isAnonymus {
                HStack {
                    Image(systemName: "eye.slash.fill")
                    Text("This Form is anonymus. Your username will not be stored.")
                }
                .font(.caption)
                .foregroundStyle(LinearGradient.brandGradient)
                .padding(.top, 4)
            }
        }
        .padding(.horizontal, 4)
    }

    @ViewBuilder
    private func questionCard(for question: Question) -> some View {
        let isError = errorQuestionId == question.id

        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    Text(question.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    if question.isRequired {
                        Text("*")
                            .font(.title3)
                            .foregroundStyle(.red)
                    }
                    Spacer()
                }

                Group {
                    switch question.type {
                    case .shortAnswer:
                        VStack(alignment: .trailing, spacing: 4) {
                            TextField("Answer...", text: textBinding(for: question))
                                .textFieldStyle(.roundedBorder)
                            let currentCount = userAnswers[question.id]?.value?.count ?? 0
                            Text("\(currentCount) / \(question.maxCharactersLimit)")
                                .font(.caption2)
                                .foregroundStyle(currentCount > question.maxCharactersLimit ? .red : .secondary)
                        }

                    case .paragraph:
                        VStack(alignment: .trailing, spacing: 4) {
                            TextEditor(text: textBinding(for: question))
                                .frame(minHeight: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(uiColor: .systemGray4), lineWidth: 1)
                                )
                            let currentCount = userAnswers[question.id]?.value?.count ?? 0
                            Text("\(currentCount) / \(question.maxCharactersLimit)")
                                .font(.caption2)
                                .foregroundStyle(currentCount > question.maxCharactersLimit ? .red : .secondary)
                        }

                    case .toggle:
                        HStack {
                            Toggle("", isOn: boolBinding(for: question))
                                .tint(LinearGradient.brandGradient)
                                .labelsHidden()
                            Spacer()
                        }

                    case .dropdown:
                        Picker("Choose", selection: textBinding(for: question)) {
                            Text("Choose...").tag("")
                            ForEach(question.options, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .tint(LinearGradient.brandGradient)
                        .cornerRadius(8)

                    case .multipleChoice:
                        VStack(alignment: .leading, spacing: 12) {
                            let binding = textBinding(for: question)

                            ForEach(question.options, id: \.self) { option in
                                Button(action: {
                                    binding.wrappedValue = option
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: binding.wrappedValue == option ? "largecircle.fill.circle" : "circle")
                                            .foregroundStyle(binding.wrappedValue == option ? AnyShapeStyle(LinearGradient.brandGradient) : AnyShapeStyle(Color.gray))
                                            .font(.title3)

                                        Text(option)
                                            .foregroundStyle(.primary)
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .frame(maxWidth: .infinity)

                    case .checkboxes:
                        VStack(alignment: .leading, spacing: 14) {
                            let binding = selectionsBinding(for: question)

                            ForEach(question.options, id: \.self) { option in
                                Button(action: {
                                    if binding.wrappedValue.contains(option) {
                                        binding.wrappedValue.removeAll { $0 == option }
                                    } else {
                                        binding.wrappedValue.append(option)
                                    }
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: binding.wrappedValue.contains(option) ? "checkmark.square.fill" : "square")
                                            .foregroundStyle(binding.wrappedValue.contains(option) ? AnyShapeStyle(LinearGradient.brandGradient) : AnyShapeStyle(Color.gray))
                                            .font(.title3)

                                        Text(option)
                                            .foregroundStyle(.primary)
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            if isError {
                Text("Please check this question before submitting.")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .transition(.opacity)
            }
        }
        .padding(20)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)

                .stroke(
                    isError ?
                        AnyShapeStyle(Color.red.opacity(0.7)) :
                        AnyShapeStyle(LinearGradient.brandGradient),
                    lineWidth: 2
                )
        )
        .frame(maxWidth: .infinity)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }

    private func textBinding(for question: Question) -> Binding<String> {
        Binding<String>(
            get: { userAnswers[question.id]?.value ?? "" },
            set: { newValue in
                if errorQuestionId == question.id {
                    errorQuestionId = nil
                }
                var answer = userAnswers[question.id] ?? Answer(questionId: question.id)
                answer.value = newValue
                userAnswers[question.id] = answer
            }
        )
    }

    private func selectionsBinding(for question: Question) -> Binding<[String]> {
        Binding<[String]>(
            get: {
                userAnswers[question.id]?.selections ?? []
            },
            set: { newValue in
                var answer = userAnswers[question.id] ?? Answer(questionId: question.id)
                answer.selections = newValue
                userAnswers[question.id] = answer
            }
        )
    }

    private func boolBinding(for question: Question) -> Binding<Bool> {
        Binding<Bool>(
            get: { userAnswers[question.id]?.booleanValue ?? false },
            set: { newValue in
                var answer = userAnswers[question.id] ?? Answer(questionId: question.id)
                answer.booleanValue = newValue
                userAnswers[question.id] = answer
            }
        )
    }

    private func submitForm() {
        Task {
            let isSuccess = await viewModel.submitForm(form: form, answers: userAnswers)
            if isSuccess {
                dismiss()
            }
        }
    }
}

#Preview {
    // Modelindeki tüm QuestionType'ları kapsayan sahte bir form oluşturuyoruz.
    let fullMockQuestions = [
        // 1. Kısa Cevap (Zorunlu)
        Question(title: "Adınız ve Soyadınız nedir?", type: .shortAnswer, isRequired: true, options: []),

        // 2. Paragraf
        Question(title: "Bu pozisyon için neden uygun olduğunuzu düşünüyorsunuz?", type: .paragraph, isRequired: false, options: [], maxCharactersLimit: 500),

        // 3. Çoktan Seçmeli (Radio Button)
        Question(title: "Hangi departman için başvuruyorsunuz?", type: .multipleChoice, isRequired: true, options: ["Yazılım", "Tasarım", "Pazarlama", "İnsan Kaynakları"]),

        // 4. Çoklu Seçim (Checkboxes)
        Question(title: "Bildiğiniz programlama dillerini işaretleyin (Birden fazla seçebilirsiniz)", type: .checkboxes, isRequired: false, options: ["Swift", "Kotlin", "Python", "JavaScript", "C#"]),

        // 5. Dropdown
        Question(title: "Tecrübe seviyeniz nedir?", type: .dropdown, isRequired: true, options: ["Junior (0-2 Yıl)", "Mid-Senior (2-5 Yıl)", "Senior (5+ Yıl)"]),

        // 6. Toggle (Zorunlu)
        Question(title: "Uygulama şartlarını ve gizlilik politikasını okudum, kabul ediyorum.", type: .toggle, isRequired: true, options: []),
    ]

    let mockForm = FormModel(
        title: "Fast Form - İş Başvuru Formu",
        ownerId: "ali123",
        explanation: "Lütfen aşağıdaki alanları eksiksiz doldurun. Başvurunuz anonim olarak değerlendirilecektir.",
        questionList: fullMockQuestions,
        createDate: Date().timeIntervalSince1970,
        isAnonymus: true
    )

    // Gradient hata vermesin diye sahte bir gradient tanımlayalım (Eğer sende yoksa)
    // Eğer senin 'Extension LinearGradient' dosyan varsa bunu silebilirsin.
    // .stroke(LinearGradient.brandgradient, lineWidth: 2) kısmı hata verirse burayı aç.
    /*
     extension LinearGradient {
         static var brandgradient: LinearGradient {
             LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
         }
     }
     */

    return ResponseChoosenFormView(form: mockForm)
}
