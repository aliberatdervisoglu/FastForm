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
    @State var question: Question
    @State private var showRequiredInfo = false // popover i Button
    @State private var showTypeInfo = false // popover i Button
    @State private var showCharLimitInfo = false // popover i Button
    
    var onSave: (Question) -> Void
    
    init(question: Question, onSave: @escaping (Question) -> Void) {
        self._question = State(initialValue: question)
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
                                onSave(question)
                                dismiss()
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
            TextField("Enter the question title...", text: $question.title, axis: .vertical)
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
                        Text(question.type.rawValue.capitalized)
                            .font(.headline)
                            .bold()
                        
                        Text(getRequiredInfoText(for: question.type))
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
            
            switch question.type {
            case .shortAnswer:
                Text("Answer: ")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white.opacity(0.8))
                shortAnswerView
            case .paragraph:
                Text("Answer: ")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white.opacity(0.8))
                paragraphAnswerView
            case .multipleChoice:
                Text("Options: ")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white.opacity(0.8))
                multipleChoiceAnswerView
            case .checkboxes:
                Text("Options: ")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white.opacity(0.8))
                checkboxesAnswerView
            case .dropdown:
                Text("Options: ")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white.opacity(0.8))
                dropdownAnswerView
            case .toggle:
                Text("Options: ")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white.opacity(0.8))
                toggleAnswerView
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
                    Text(question.type.rawValue.capitalized)
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
            
            TextField("50", value: $question.maxCharactersLimit, format: .number)
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
                    Text(question.type.rawValue.capitalized)
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
            
            TextField("50", value: $question.maxCharactersLimit, format: .number)
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
    @ViewBuilder
    var multipleChoiceAnswerView: some View {
        VStack {
            BigButtonView(title: "ADD option") {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        question.options.append("")
                    }
            }
            .padding(.bottom, 20)
            if question.options.isEmpty {
                ContentUnavailableView("No option!", image: "plus")
                        .opacity(0)
                        .frame(height: 1)
                }
            ForEach(0..<question.options.count, id: \.self) { index in
                HStack {
                    Image(systemName: "circle")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white)
                    TextField("Option \(index + 1)", text: Binding(
                        get: { // if index valid, bring data
                            question.options.indices.contains(index) ?
                            question.options[index] : ""
                        },
                        set: { newValue in // if index valid, save data
                            if question.options.indices.contains(index) {
                                question.options[index] = newValue
                            }
                        }
                    ))
                        .padding(10)
                        .font(.headline)
                        .bold()
                        .foregroundStyle(.black.opacity(0.8))
                        .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
                    Button {
                        
                        if question.options.indices.contains(index) {
                            _ = withAnimation(.easeInOut) {
                                question.options.remove(at: index)
                            }
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundStyle(.red.opacity(0.8))
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .opacity))
                
            }
            
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: question.options.count)
        
    }
    @ViewBuilder
    var checkboxesAnswerView: some View {
        VStack {
            BigButtonView(title: "ADD option") {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        question.options.append("")
                    }
            }
            .padding(.bottom, 20)
            if question.options.isEmpty {
                ContentUnavailableView("No option!", image: "plus")
                        .opacity(0)
                        .frame(height: 1)
                }
            ForEach(0..<question.options.count, id: \.self) { index in
                HStack {
                    Image(systemName: "square")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white)
                    TextField("Option \(index + 1)", text: Binding(
                        get: { // if index valid, bring data
                            question.options.indices.contains(index) ?
                            question.options[index] : ""
                        },
                        set: { newValue in // if index valid, save data
                            if question.options.indices.contains(index) {
                                question.options[index] = newValue
                            }
                        }
                    ))
                        .padding(10)
                        .font(.headline)
                        .bold()
                        .foregroundStyle(.black.opacity(0.8))
                        .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
                    Button {
                        
                        if question.options.indices.contains(index) {
                            _ = withAnimation(.easeInOut) {
                                question.options.remove(at: index)
                            }
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundStyle(.red.opacity(0.8))
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .opacity))
                
            }
            
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: question.options.count)
    }
    @ViewBuilder
    var dropdownAnswerView: some View {
        VStack {
            BigButtonView(title: "ADD option") {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        question.options.append("")
                    }
            }
            .padding(.bottom, 20)
            if question.options.isEmpty {
                ContentUnavailableView("No option!", image: "plus")
                        .opacity(0)
                        .frame(height: 1)
                }
            ForEach(0..<question.options.count, id: \.self) { index in
                HStack {
                    Image(systemName: "chevron.down")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white)
                    TextField("Option \(index + 1)", text: Binding(
                        get: { // if index valid, bring data
                            question.options.indices.contains(index) ?
                            question.options[index] : ""
                        },
                        set: { newValue in // if index valid, save data
                            if question.options.indices.contains(index) {
                                question.options[index] = newValue
                            }
                        }
                    ))
                        .padding(10)
                        .font(.headline)
                        .bold()
                        .foregroundStyle(.black.opacity(0.8))
                        .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
                    Button {
                        
                        if question.options.indices.contains(index) {
                            _ = withAnimation(.easeInOut) {
                                question.options.remove(at: index)
                            }
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundStyle(.red.opacity(0.8))
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .opacity))
                
            }
            
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: question.options.count)
    }
    
    @ViewBuilder
    var toggleAnswerView: some View {
        HStack{
            Image(systemName: "switch.2")
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.8))
            Text("Users will see a switch")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.8))
            Spacer()
            Toggle(isOn: .constant(true)) {
                EmptyView()
            }
            .labelsHidden()
            .disabled(true)
            
        }
        .padding(15)
            .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
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
            type: .toggle,
            isRequired: true,
            options: ["Seçenek 1", "Seçenek 2"]
        ),
        onSave: { updatedQuestion in
            print("Preview'da Kaydedildi: \(updatedQuestion.title)")
        }
    )
}
