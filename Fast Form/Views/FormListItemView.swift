//
//  FormListItemView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 22.02.2026.
//

import SwiftUI

struct FormListItemView: View {
    @StateObject var viewModel = FormListItemViewViewModel()
    var item: FormModel
    var onDelete: () -> Void
    
    var body: some View {
        HStack{
            
            VStack(alignment: .leading, spacing: 5){
                Text(item.title)
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                Text(item.explanation)
                    .font(.title2)
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 5){
                NavigationLink(destination:FormBuilderView(item: .constant(FormModel(
                    id: "test_id",
                    title: "Örnek Form",
                    ownerId: "user_123",
                    explanation: "Bu bir test açıklamasıdır.",
                    questionList: [],
                    createDate: Date().timeIntervalSince1970,
                    isAnonymus: true
                )))) {
                        Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundStyle(.white)
                }
                Button {
                    onDelete()
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

        
//        .background(Color("BrandGradientStart").opacity(0.2))

        
    }
}

#Preview {
    FormListItemView(item: FormModel(title: "TITLE", ownerId: "asdad", explanation: "dawda\ngdbawd", questionList: [Question(title: "dscs", type: QuestionType.paragraph, isRequired: true)], createDate: Date().timeIntervalSince1970, isAnonymus: true)) {
        print("hi")
    }
}
