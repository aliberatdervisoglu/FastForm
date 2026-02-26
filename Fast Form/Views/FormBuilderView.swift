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
    
    var body: some View {
        NavigationStack{
            ScrollView{
                formInfoView
                Divider().background(.gray.opacity(0.8))
                    .padding(15)
                ForEach(item.questionList){question in
//                    FormListItemView(item: quesiton){
//                        self.itemToDelete = item
//                        self.showingDeleteAlert = true
//                    }
                }
                Spacer()
                Spacer()
                BigButtonView(title: "Add") {
                    print("hi")
                }
                
            }
            .navigationTitle("Build & Edit Form")

        }
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
        questionList: [Question(id: "sdçcs", title: "şsdlöcsc", type: QuestionType.paragraph, isRequired: true, options: ["scsd"])],
        createDate: Date().timeIntervalSince1970,
        isAnonymus: true
    )))
}
