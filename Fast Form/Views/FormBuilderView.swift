//
//  FormBuilderView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import SwiftUI

struct FormBuilderView: View {
    @StateObject var viewModel = FormBuilderViewViewModel()
    @Binding var item: FormModel
    @State private var selectedQuestion: Question? = nil // to add direct sheet link to add button
    
    var body: some View {
        NavigationStack{
            ScrollView{
                formInfoView
                Divider().background(.gray.opacity(0.8))
                    .padding(15)
                
                Spacer()
                BigButtonView(title: "Add new question") {
                    let newQuestion = viewModel.createNewQuestion()
                    item.questionList.append(newQuestion)
                    selectedQuestion = newQuestion
                }
                .sheet(item: $selectedQuestion) { question in
                    NewQuestionView(question: question, onSave: { updatedQuestion in

                        print("Preview'da Kaydedildi: \(updatedQuestion.title)")
                    })
                        .presentationDetents([.medium,.large]) // the half of screen or full of screen
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
        viewModel.save(item: item)
        // Kayıt bitince taslağı boşalt ki bir sonraki "Create" sekmesine basışta boş gelsin
        self.item = FormModel(
                        id: UUID().uuidString,
                        title: "",
                        ownerId: "", // Backend zaten Auth'dan alacak
                        explanation: "",
                        questionList: [],
                        createDate: Date().timeIntervalSince1970,
                        isAnonymus: false
                    )
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
                    .foregroundStyle(.white.opacity(0.8))
                    .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))

                
            }
            Divider().background(.white.opacity(0.8))
            VStack(alignment: .leading,spacing: 5){
                Text("Explanation: ")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white.opacity(0.8))
                TextField("Enter a title...", text: $item.title, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
                    .font(.title2)
                    .bold()
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.white.opacity(0.8))
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
    FormBuilderView(item: .constant(FormModel(
        id: "test_id",
        title: "Örnek Form",
        ownerId: "user_123",
        explanation: "Bu bir test açıklamasıdır.",
        questionList: [Question(id: "sdçcs", title: "şsdlöcsc", type: QuestionType.paragraph, isRequired: true, options: ["scsd"]),Question(id: "sdçcs", title: "şsdlöcsc", type: QuestionType.paragraph, isRequired: true, options: ["scsd"]),Question(id: "sdçcs", title: "şsdlöcsc", type: QuestionType.paragraph, isRequired: true, options: ["scsd"]),Question(id: "sdçcs", title: "şsdlöcsc", type: QuestionType.paragraph, isRequired: true, options: ["scsd"])],
        createDate: Date().timeIntervalSince1970,
        isAnonymus: true
    )))
}
