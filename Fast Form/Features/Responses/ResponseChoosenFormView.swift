//
//  ResponseChoosenFormView.swift
//  Fast Form
//

import SwiftUI

struct ResponseChoosenFormView: View {
    let form: FormModel

    @State private var viewModel = ResponseChoosenFormViewViewModel()
    @State private var userAnswers: [String: Answer] = [:]
    @State private var errorQuestionId: String? = nil

    // UI State handled locally in the View
    @State private var showAlert = false
    @State private var errorMessage = ""

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
                                questionCard(for: question).id(question.id)
                            }
                        }

                        BigButtonView(title: "Send Form") {
                            handleFormSubmission()
                        }
                    }
                    .padding()
                    .onChange(of: errorQuestionId) { _, newValue in
                        if let id = newValue {
                            withAnimation(.spring()) { proxy.scrollTo(id, anchor: .center) }
                        }
                    }
                }
            }
            .alert("Alert", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .overlay {
                if viewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.4).ignoresSafeArea()
                        ProgressView("Sending...").padding().background(.white).cornerRadius(10)
                    }
                }
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Fill form")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Actions

    private func handleFormSubmission() {
        do {
            try viewModel.validateAnswers(form: form, answers: userAnswers)
            errorQuestionId = nil
            submitForm()
        } catch let ResponseManagerError.validationFailed(id, message) {
            errorQuestionId = id
            errorMessage = message
            showAlert = true
        } catch {
            errorMessage = error.localizedDescription
            showAlert = true
        }
    }

    private func submitForm() {
        Task {
            do {
                try await viewModel.submitForm(form: form, answers: userAnswers)
                await MainActor.run { dismiss() }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }

    // MARK: - Bindings

    private func textBinding(for question: Question) -> Binding<String> {
        Binding(
            get: { userAnswers[question.id]?.value ?? "" },
            set: { userAnswers[question.id, default: Answer(questionId: question.id)].value = $0 }
        )
    }

    private func selectionsBinding(for question: Question) -> Binding<[String]> {
        Binding(
            get: { userAnswers[question.id]?.selections ?? [] },
            set: { userAnswers[question.id, default: Answer(questionId: question.id)].selections = $0 }
        )
    }

    private func boolBinding(for question: Question) -> Binding<Bool> {
        Binding(
            get: { userAnswers[question.id]?.booleanValue ?? false },
            set: { userAnswers[question.id, default: Answer(questionId: question.id)].booleanValue = $0 }
        )
    }

    // MARK: - Components

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(form.title).font(.title).fontWeight(.bold)
            Text(form.explanation).font(.subheadline).foregroundStyle(.secondary)
            if form.isAnonymus {
                HStack {
                    Image(systemName: "eye.slash.fill")
                    Text("This Form is anonymous. Your username will not be stored.")
                }
                .font(.caption).foregroundStyle(LinearGradient.brandGradient).padding(.top, 4)
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
                    Text(question.title).font(.headline).foregroundStyle(.primary)
                    if question.isRequired { Text("*").font(.title3).foregroundStyle(.red) }
                    Spacer()
                }
                Group {
                    switch question.type {
                    case .shortAnswer:
                        VStack(alignment: .trailing, spacing: 4) {
                            TextField("Answer...", text: textBinding(for: question)).textFieldStyle(.roundedBorder)
                            let count = userAnswers[question.id]?.value?.count ?? 0
                            Text("\(count) / \(question.maxCharactersLimit)").font(.caption2).foregroundStyle(count > question.maxCharactersLimit ? .red : .secondary)
                        }
                    case .paragraph:
                        VStack(alignment: .trailing, spacing: 4) {
                            TextEditor(text: textBinding(for: question)).frame(minHeight: 100).overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(uiColor: .systemGray4), lineWidth: 1))
                            let count = userAnswers[question.id]?.value?.count ?? 0
                            Text("\(count) / \(question.maxCharactersLimit)").font(.caption2).foregroundStyle(count > question.maxCharactersLimit ? .red : .secondary)
                        }
                    case .toggle:
                        HStack { Toggle("", isOn: boolBinding(for: question)).tint(LinearGradient.brandGradient).labelsHidden(); Spacer() }
                    case .dropdown:
                        Picker("Choose", selection: textBinding(for: question)) {
                            Text("Choose...").tag("")
                            ForEach(question.options, id: \.self) { Text($0).tag($0) }
                        }
                        .pickerStyle(.menu).frame(maxWidth: .infinity).padding(.vertical, 8).background(Color(uiColor: .secondarySystemBackground)).tint(LinearGradient.brandGradient).cornerRadius(8)
                    case .multipleChoice:
                        VStack(alignment: .leading, spacing: 12) {
                            let binding = textBinding(for: question)
                            ForEach(question.options, id: \.self) { option in
                                Button(action: { binding.wrappedValue = option }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: binding.wrappedValue == option ? "largecircle.fill.circle" : "circle").foregroundStyle(binding.wrappedValue == option ? AnyShapeStyle(LinearGradient.brandGradient) : AnyShapeStyle(Color.gray)).font(.title3)
                                        Text(option).foregroundStyle(.primary); Spacer()
                                    }
                                }.buttonStyle(.plain)
                            }
                        }
                    case .checkboxes:
                        VStack(alignment: .leading, spacing: 14) {
                            let binding = selectionsBinding(for: question)
                            ForEach(question.options, id: \.self) { option in
                                Button(action: {
                                    if binding.wrappedValue.contains(option) { binding.wrappedValue.removeAll { $0 == option } }
                                    else { binding.wrappedValue.append(option) }
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: binding.wrappedValue.contains(option) ? "checkmark.square.fill" : "square").foregroundStyle(binding.wrappedValue.contains(option) ? AnyShapeStyle(LinearGradient.brandGradient) : AnyShapeStyle(Color.gray)).font(.title3)
                                        Text(option).foregroundStyle(.primary); Spacer()
                                    }
                                }.buttonStyle(.plain)
                            }
                        }
                    }
                }
            }

            if isError {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .transition(.opacity)
            }
        }
        .padding(20).background(Color(uiColor: .systemBackground)).cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(isError ? AnyShapeStyle(Color.red.opacity(0.7)) : AnyShapeStyle(LinearGradient.brandGradient), lineWidth: 2))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}
