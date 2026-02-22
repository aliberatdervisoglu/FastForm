//
//  FormListView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 22.02.2026.
//

import SwiftUI

struct FormListView: View {
    @StateObject var viewModel = FormListViewViewModel()
    
    var formitems: [FormModel]
    
    var body: some View {
        NavigationStack{
            VStack{
                // maybe in List
                ForEach(formitems){item in
                    FormListItemView(item: item)
                }
            }
        }
        .navigationTitle("My Forms")
    }
}

#Preview {
    FormListView(formitems: [FormModel(id: "vefvvfe", title: "TITLE", ownerId: "asdad", explanation: "dawda\ngdbawd", questionList: [Question(id: "kmlm", title: "dscs", type: QuestionType.paragraph, isRequired: true)], createDate: Date().timeIntervalSince1970, isAnonymus: true)])
}
