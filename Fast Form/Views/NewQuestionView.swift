//
//  NewQuestionView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//
//  aşağıdan kaydırmalı olarak formbuildera ekleyelim...

import SwiftUI

struct NewQuestionView: View {
    @Binding var question: Question
    @State private var showRequiredInfo = false
    @State private var showTypeInfo = false
    
    
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
                        questionDynamicAnswerSectionView
                    }
                    .padding()
                }
                .navigationTitle("Question")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            print("Tapped")
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title)
                                .foregroundStyle(Color(.green))
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
            TextField("Enter the question title...", text: .constant(""), axis: .vertical)
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
                .popover(isPresented: $showRequiredInfo) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(question.type.rawValue.capitalized)
                            .font(.headline)
                            .bold()
                        
                        Text(getRequiredInfoText(for: question.type)) // Fonksiyondan gelen metni yazdırır
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(width: 250)
                    .presentationCompactAdaptation(.popover)
                }
                Spacer()
                
                Picker("question type picker", selection: $question.type){
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
                Toggle("", isOn: $question.isRequired)
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
            switch question.type {
            case .shortAnswer:
                TextField("Text...", text: .constant(""))
                    .padding(10)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.black.opacity(0.8))
                    .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
                    .disabled(true)
                
            case .paragraph:
                TextField("Text...", text: .constant(""), axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
                    .font(.title2)
                    .bold()
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.black.opacity(0.8))
                    .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
                    .disabled(true)
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
    NewQuestionView(question: .constant(Question(id: "sdçcs", title: "şsdlöcsc", type: QuestionType.paragraph, isRequired: true, options: ["scsd"])))
}
