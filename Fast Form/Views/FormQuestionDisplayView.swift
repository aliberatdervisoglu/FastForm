//
//  FormQuestionDisplayView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 26.02.2026.
//

import SwiftUI

struct FormQuestionDisplayView: View {
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
                NavigationLink(destination: NewQuestionView(question: question)) {
                        Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundStyle(.white)
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
