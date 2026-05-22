//
//  FormBuilderView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import SwiftUI

struct FormBuilderView: View {
    
    @State var viewModel: FormBuilderViewViewModel
    @State var item: FormModel
    @State private var selectedQuestion: Question? = nil // to add direct sheet link to add button
    @State private var showSuccessAnimation = false
    
    @State private var showSaveError = false
    @State private var showSaveErrorMessage = ""

    @Environment(\.dismiss) var dismiss
    @Binding var tabSelection: Int
    init(formToEdit: FormModel? = nil, tabselection: Binding<Int>){
        if let incomingForm = formToEdit{
            self._item = State(initialValue: incomingForm)
        } else {
            self._item = State(initialValue: FormModel(
                id: UUID().uuidString,
                title: "",
                ownerId: "",
                explanation: "",
                questionList: [],
                createDate: Date().timeIntervalSince1970,
                isAnonymus: false
                        ))
        }
        self._viewModel = State(wrappedValue: FormBuilderViewViewModel())
        self._tabSelection = tabselection
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                
                List{
                    VStack{
                        formInfoView
                        Divider().background(.gray.opacity(0.8))
                            .padding(15)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    
                    VStack {
                        Spacer().frame(height: 5)
                        BigButtonView(title: "Add new question") {
                            let newQuestion = viewModel.createNewQuestion()
                                selectedQuestion = newQuestion
                        }
                        Spacer().frame(height: 20)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
            
                    ForEach($item.questionList) { $question in
                        FormQuestionDisplayView(question: $question)
                            .padding(5)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    if let index = item.questionList.firstIndex(where: { $0.id == question.id }) {
                                        item.questionList.remove(at: index)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .contentShape(Rectangle()) 
                            .onTapGesture {
                                self.selectedQuestion = question
                                    }

                    }
                    
                    .onMove { source, destination in
                        item.questionList.move(fromOffsets: source, toOffset: destination)
                    }
                    
                   
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                
                
                .animation(.easeInOut, value: item.questionList.count)

                // SHEET FOR NEW QUESTION AND SET QUESTION
                .sheet(item: $selectedQuestion) { question in
                    NewQuestionView(question: question, onSave: { updatedQuestion in
                        
                        
                        // te opened sheet gives us a arranged question and we search the index of late version of this question and update in our binding list
                        if let index = item.questionList.firstIndex(where: { $0.id == updatedQuestion.id }) {
                            item.questionList[index] = updatedQuestion
                        } else {
                        // if we cannot find the quetion in our list we add this to our list here: FOR NEW QUESTION
                            item.questionList.append(updatedQuestion)
                        }
                    })
//                    .presentationDetents([.medium,.large]) // the half of screen or full of screen
                    .presentationDragIndicator(.visible) // single line to hold above
                }
                
                .navigationTitle("Build & Edit Form")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                            EditButton()
                                .font(.headline)
                                .foregroundStyle(.gray)
                        }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        Button {
                            if saveAndReset(){
                                if tabSelection == 2 {
                                    tabSelection = 0
                                } else {
                                    dismiss()
                                }
                            }
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title)
                                .foregroundStyle(Color(.green))
                        }
                    }
                }
            }
            .alert("FormBuilder Error", isPresented: $showSaveError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(showSaveErrorMessage)
            }
        }
    }
    func saveAndReset() -> Bool{

        for i in 0..<item.questionList.count {
            item.questionList[i].options = item.questionList[i].options.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        }
        
        if item.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showSaveErrorMessage = "Please enter a valid title for your form!"
            showSaveError = true
            return false
        }
        guard !item.questionList.isEmpty else {
            showSaveErrorMessage = "Your form must have at least one question!"
            showSaveError = true
            return false
        }
        
        viewModel.save(item: item)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        DispatchQueue.main.async {
            self.item = FormModel(
                id: UUID().uuidString,
                title: "",
                ownerId: "",
                explanation: "",
                questionList: [],
                createDate: Date().timeIntervalSince1970,
                isAnonymus: false)
        }
        return true
        
    }
    
    @ViewBuilder
    var formInfoView : some View {
        VStack(alignment: .leading,spacing: 5) {
            VStack(alignment: .leading,spacing: 5){
                Text("Title: ")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white.opacity(0.8))
                TextField("Enter a title...", text: $item.title)
                    .font(.title2)
                    .bold()
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.black.opacity(0.8))
                    .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))

                
            }
            Divider().background(.white.opacity(0.8))
            VStack(alignment: .leading,spacing: 5){
                Text("Explanation: ")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white.opacity(0.8))
                TextField("Enter a title...", text: $item.explanation, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
                    .font(.title2)
                    .bold()
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.black.opacity(0.8))
                    .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
                
                
            }
            Divider().background(.white.opacity(0.8))
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Created At: ")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white.opacity(0.8))
                Text(Date(timeIntervalSince1970: item.createDate).formatted(date: .abbreviated, time: .shortened))
                    .font(.title2)
                    .bold()
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.white.opacity(0.8))
                    .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))


            }
            Divider().background(.white.opacity(0.8))

            HStack(alignment: .center) {
                Toggle("Anonymous: ", isOn: $item.isAnonymus)
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white.opacity(0.8))
                    .tint(.white.opacity(0.5))
                
                
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient.brandGradient)
        )
        .padding(.horizontal)
    }

    
    
//    @ViewBuilder
//    var questionSection: some View {
//        
//    }
//    
    
}

#Preview {
    FormBuilderView(formToEdit: nil, tabselection: .constant(1))
}
