//
//  NewQuestionView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//
//  aşağıdan kaydırmalı olarak formbuildera ekleyelim...

import SwiftUI

struct NewQuestionView: View {
    @Environment(\.dismiss) var dismiss //  to close without save
    @StateObject var viewModel: NewQuestionViewViewModel //  we use init for viewmodel
    @State private var showRequiredInfo = false // popover i Button
    @State private var showTypeInfo = false // popover i Button
    @State private var showCharLimitInfo = false // popover i Button
    
    var onSave: (Question) -> Void
    
    init(question: Question, onSave: @escaping (Question) -> Void) {
        self._viewModel = StateObject(wrappedValue: NewQuestionViewViewModel(question: question))
        self.onSave = onSave
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.brandGradient
                    .ignoresSafeArea()
                    .opacity(0.7)
                ScrollView {
                    VStack(spacing: 25) {
                        //--- 1.PART QUESTION ---
                        questionHeaderSectionView
                        //--- 2.PART TYPE AND SETTINGS ---
                        questionSettingsSectionView
                        //--- 3.PART DYNAMIC ANSWERS ---
                        Divider() // Araya şık bir çizgi atar
                                .background(.white.opacity(0.3))
                                .padding(.vertical, 5)
                        questionDynamicAnswerSectionView
                    }
                    .padding()
                }
                .navigationTitle("Question")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            // viewmodel gives as the pack the copy of question but updated version
                            viewModel.save{ updatedquestion in
                                // From completion(question) quesion is as updatedquestion here. like a boomerang
                                onSave(updatedquestion)
                                dismiss()
                            }
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title)
                                .foregroundStyle(Color(.green))
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundStyle(Color(.red))
                        }
                    }
                }
            }
        }
    }
    @ViewBuilder
    var questionHeaderSectionView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Title: ")
                .font(.title)
                .bold()
                .foregroundStyle(.white.opacity(0.8))
            TextField("Enter the question title...", text: $viewModel.question.title, axis: .vertical)
                .lineLimit(3, reservesSpace: true)
                .font(.title2)
                .bold()
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.black.opacity(0.8))
                .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
        }
    }
    @ViewBuilder
    var questionSettingsSectionView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 5) {
                Text("Type: ")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white.opacity(0.8))
                Button {
                    showTypeInfo = true
                } label: {
                    Image(systemName: "info.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
                
                .popover(isPresented: $showTypeInfo) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(viewModel.question.type.rawValue.capitalized)
                            .font(.headline)
                            .bold()
                        
                        Text(getRequiredInfoText(for: viewModel.question.type))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(width: 250)
                    .presentationCompactAdaptation(.popover)
                }
                Spacer()
                
                Picker("question type picker", selection: $viewModel.question.type){
                    ForEach(QuestionType.allCases, id: \.self) {type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.menu)
                
                .frame(maxWidth: .infinity)
                .tint(.black.opacity(0.8))
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
                
            }
            
            HStack(spacing: 5) {
                Text("Required:")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white.opacity(0.8))
                
                Button {
                    showRequiredInfo = true
                } label: {
                    Image(systemName: "info.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
                .popover(isPresented: $showRequiredInfo) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Required Question")
                            .font(.headline)
                            .bold()
                        
                        Text("If you turn this on, users will not be able to submit the form without answering this question.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(width: 250)
                    .presentationCompactAdaptation(.popover)
                }
                
                
                Spacer()
                Toggle("", isOn: $viewModel.question.isRequired)
                    .labelsHidden()
                    .tint(.green)
            }
        }
        
    }
    @ViewBuilder
    var questionDynamicAnswerSectionView: some View {
        VStack(alignment: .leading,spacing: 5) {
            Text("Answer: ")
                .font(.title)
                .bold()
                .foregroundStyle(.white.opacity(0.8))
            switch viewModel.question.type {
            case .shortAnswer:
                shortAnswerView
            case .paragraph:
                paragraphAnswerView
            case .multipleChoice:
                Text("")
            case .checkboxes:
                Text("")
            case .dropdown:
                Text("")
            case .toggle:
                Text("")
            }
        }
        
        
    }
    @ViewBuilder
    var shortAnswerView: some View {
        HStack(spacing: 5) {
            Text("Character Limit: ")
                .font(.title3)
                .bold()
                .foregroundStyle(.white.opacity(0.8))
            Button {
                showCharLimitInfo = true
            } label: {
                Image(systemName: "info.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.white)
            }
            .popover(isPresented: $showCharLimitInfo) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(viewModel.question.type.rawValue.capitalized)
                        .font(.headline)
                        .bold()
                    
                    Text("Set the maximum number of characters allowed for this response.\n\n💡 Tip: A limit between 30 and 70 characters is usually ideal for names, email addresses, or brief answers.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(width: 250)
                .presentationCompactAdaptation(.popover)
            }
            Spacer()
            
            TextField("50", value: $viewModel.question.maxCharactersLimit, format: .number)
                .padding(10)

                .keyboardType(.numberPad)
                .font(.headline)
                .foregroundStyle(.black.opacity(0.8))
                .frame(width: 100)
                .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
        }
        TextField("Text...", text: .constant(""))
            .padding(10)
            .font(.title2)
            .bold()
            .foregroundStyle(.black.opacity(0.8))
            .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
            .disabled(true)
        
    }
    @ViewBuilder
    var paragraphAnswerView: some View {
        HStack(spacing: 5) {
            Text("Character Limit: ")
                .font(.title3)
                .bold()
                .foregroundStyle(.white.opacity(0.8))
            Button {
                showCharLimitInfo = true
            } label: {
                Image(systemName: "info.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.white)
            }
            .popover(isPresented: $showCharLimitInfo) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(viewModel.question.type.rawValue.capitalized)
                        .font(.headline)
                        .bold()
                    
                    Text("Set the minimum and maximum number of characters allowed for this detailed response.\n\n💡 Tip: A minimum of 100 characters encourages thoughtful answers, while a maximum of 500-1000 keeps them readable.")                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(width: 250)
                .presentationCompactAdaptation(.popover)
            }
            Spacer()
            
            TextField("50", value: $viewModel.question.maxCharactersLimit, format: .number)
                .padding(10)

                .keyboardType(.numberPad)
                .font(.headline)
                .foregroundStyle(.black.opacity(0.8))
                .frame(width: 100)
                .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
        }
        TextField("Text...", text: .constant(""), axis: .vertical)
            .lineLimit(3, reservesSpace: true)
            .font(.title2)
            .bold()
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.black.opacity(0.8))
            .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
            .disabled(true)
    }
    
    
    func getRequiredInfoText(for type: QuestionType) -> String {
        switch type {
        case .shortAnswer:
            return "Users must enter a brief text response in the field to proceed."
        case .paragraph:
            return "Users must provide a detailed, multi-line text response before submitting."
        case .multipleChoice:
            return "Users must select exactly one option from the list to submit the form."
        case .checkboxes:
            return "Users must check at least one option to proceed."
        case .dropdown:
            return "Users must choose a valid option from the dropdown menu."
        case .toggle:
            return "Users must turn this switch ON (e.g., agreeing to Terms of Service) to submit."
        }
    }
}

#Preview {
    NewQuestionView(
        question: Question(
            id: "test-id-123",
            title: "Örnek Soru Başlığı",
            type: .paragraph,
            isRequired: true,
            options: ["Seçenek 1", "Seçenek 2"]
        ),
        onSave: { updatedQuestion in
            print("Preview'da Kaydedildi: \(updatedQuestion.title)")
        }
    )
}
