//
//  FormQuestionDisplayView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 26.02.2026.
//

import SwiftUI

struct FormQuestionDisplayView: View {
    @State var isEditingQuestion: Bool = false
    @Binding var question: Question
    var body: some View {
        
        HStack{
            
            VStack(alignment: .leading, spacing: 5){
                Text(question.title)
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 5){
                Button{
                    isEditingQuestion = true // to open toggle
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundStyle(.white)
                }
                .sheet(isPresented: $isEditingQuestion) {
                    NewQuestionView(question: question, onSave: {  updatedQuestion in
                        
                        print("Preview'da Kaydedildi: \(updatedQuestion.title)")
                        }
                    )
                        .presentationDetents([.medium,.large]) // the half of screen or full of screen
                        .presentationDragIndicator(.visible) // single line to hold above
                }
                
                
                Button {
                    print("delete question")
                } label: {
                    Image(systemName: "trash.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundStyle(.white)
                }

                
            }
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient.brandGradient))
        .padding(.horizontal)

        
        
    }
}

#Preview {
    FormQuestionDisplayView(question: .constant(Question(
        id: "preview_q_1",
        title: "En sevdiğin programlama dili hangisi?",
        type: .paragraph,
        isRequired: true,
        options: []
    )))
    
}
