//
//  ResponseFormView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import SwiftUI

struct ResponseFormView: View {
    @StateObject var viewModel = ResponseFormViewViewModel()
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                List(viewModel.results) { form in
                    NavigationLink(destination: ResponseChoosenFormView(form: form)) {
                        VStack(alignment: .leading) {
                            Text(form.title)
                                .font(.headline)
                            Text(form.explanation)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .navigationTitle("Find Form")
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Enter a Form Title...")                .onChange(of: viewModel.searchText) {
                    viewModel.searchForms()
                }
            }
        }
    }
}

#Preview {
    ResponseFormView()
}
