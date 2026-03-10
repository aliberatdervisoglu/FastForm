//
//  FormBuilderView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import SwiftUI

struct FormBuilderView: View {
    
    @StateObject var viewModel: FormBuilderViewViewModel
    @State var item: FormModel
    @State private var selectedQuestion: Question? = nil // to add direct sheet link to add button
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
        self._viewModel = StateObject(wrappedValue: FormBuilderViewViewModel())
        self._tabSelection = tabselection
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                formInfoView
                Divider().background(.gray.opacity(0.8))
                    .padding(15)
                
                Spacer()
                BigButtonView(title: "Add new question") {
                    let newQuestion = viewModel.createNewQuestion()
//                    item.questionList.append(newQuestion) don!t append yet because if we append it there, our form may include some empty question.
                    selectedQuestion = newQuestion
                }
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
                
                
                ForEach($item.questionList) { $question in
                    FormQuestionDisplayView(question: $question)
                }
                
                Spacer()
                
            }
            .navigationTitle("Build & Edit Form")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        saveAndReset()
                        if tabSelection == 2 {
                            tabSelection = 0
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(Color(.green))
                    }
                }
            }

        }
    }
    func saveAndReset() {

        guard !item.questionList.isEmpty else {
            print("There should be at least one question in a form!")
            //TODO: we will give an alert to user,later
            return
        }

        guard !item.title.isEmpty else {
            print("The title cannot be empty!")
            //TODO: we will give another alert to user, later
            return
        }
        
        viewModel.save(item: item)
        
        self.item = FormModel(
            id: UUID().uuidString,
            title: "",
            ownerId: "",
            explanation: "",
            questionList: [],
            createDate: Date().timeIntervalSince1970,
            isAnonymus: false)
        
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
