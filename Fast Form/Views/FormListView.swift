//
//  FormListView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 22.02.2026.
//

import SwiftUI

struct FormListView: View {
    @StateObject var viewModel: FormListViewViewModel
    
    @State private var showingDeleteAlert: Bool = false
    @State private var itemToDelete: FormModel? = nil

    
    init(userId: String){
        self._viewModel = StateObject(wrappedValue: FormListViewViewModel(userID: userId))
    }
    var body: some View {
        NavigationStack{
            ZStack {
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                ScrollView {
                    VStack{
                        ForEach(viewModel.formitems){item in
                            FormListItemView(item: item){
                                self.itemToDelete = item
                                self.showingDeleteAlert = true
                            }
                        }
                        Spacer()
                    }
                    .navigationTitle("My Forms")
                    .alert("Delete Form", isPresented: $showingDeleteAlert) {
                        Button("Delete", role: .destructive) {
                            if let id = itemToDelete?.id {
                                viewModel.deleteForm(id: id)
                            }
                        }
                        Button("Cancel", role: .cancel) {  }
                    } message: {
                        Text("'\(itemToDelete?.title ?? "Unknown Form" )' will be deleted. Are you sure?")
                    }
                }
            }
            
            
    
        }
        .onAppear {
            viewModel.fetchForms()
            
            
        }
    }
}

#Preview {
    FormListView(userId: "UiJ9L9CvhXgDUa19COge2C7y2RB3")
    
}
