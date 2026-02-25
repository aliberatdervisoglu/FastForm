//
//  FormListView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 22.02.2026.
//

import SwiftUI

struct FormListView: View {
    @StateObject var viewModel: FormListViewViewModel
    
    init(userId: String){
        self._viewModel = StateObject(wrappedValue: FormListViewViewModel(userID: userId))
    }
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack{
                    ForEach(viewModel.formitems){item in
                        FormListItemView(item: item){
                            viewModel.deleteForm(id: item.id)
                        }
                        
                    }
                    Spacer()
                }
                .navigationTitle("My Forms")
            }

        }
    }
}

#Preview {
    FormListView(userId: "UiJ9L9CvhXgDUa19COge2C7y2RB3")
    
}
