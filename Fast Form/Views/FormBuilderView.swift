//
//  FormBuilderView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import SwiftUI

struct FormBuilderView: View {
    var formToEdit: FormModel
    var body: some View {
        Text(" form builder  ")
        
    }
}

#Preview {
    FormBuilderView(formToEdit: FormModel(id: "jnlnj", title: "kmkm", ownerId: "kşmşk", explanation: "mşkmşk", questionList: [Question(title: "dscsacdadd", type: QuestionType.paragraph, isRequired: true)], createDate: Date().timeIntervalSince1970, isAnonymus: true))
}
