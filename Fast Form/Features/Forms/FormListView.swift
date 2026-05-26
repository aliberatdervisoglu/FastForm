//
//  FormListView.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 22.02.2026.
//

import SwiftUI

struct FormListView: View {
    @State var viewModel: FormListViewViewModel

    @State private var showingDeleteAlert: Bool = false
    @State private var itemToDelete: FormModel? = nil

    init(userId: String) {
        _viewModel = State(wrappedValue: FormListViewViewModel(userId: userId))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                ScrollView {
                    VStack {
                        ForEach(viewModel.sortedforms) { item in // display sortversion
                            FormListItemView(item: item) {
                                itemToDelete = item
                                showingDeleteAlert = true
                            }
                        }
                        Spacer()
                    }
                    .navigationTitle("My Forms")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) { // the sort button
                            Menu {
                                Picker("Sort by", selection: $viewModel.sortOption) {
                                    ForEach(FormSortOption.allCases, id: \.self) { option in
                                        Text(option.rawValue).tag(option)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(viewModel.sortOption.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Image(systemName: "chevron.up.chevron.down")
                                        .font(.caption)
                                }
                                .foregroundStyle(LinearGradient.brandGradient)
                                .padding()
                                .padding(.horizontal)
                            }
                        }
                    }

                    .alert("Delete Form", isPresented: $showingDeleteAlert) {
                        Button("Delete", role: .destructive) {
                            if let id = itemToDelete?.id {
                                Task {
                                    do {
                                        try await viewModel.deleteForm(id: id)
                                    } catch {
                                        print("Failed to delete form: \(error)")
                                    }
                                }
                            }
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("'\(itemToDelete?.title ?? "Unknown Form")' will be deleted. Are you sure?")
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchForms()
        }
        .animation(.easeInOut, value: viewModel.sortOption) // to resort
        .animation(.easeInOut, value: viewModel.formitems.count) // to delete anything or open this window
    }
}

#Preview {
    FormListView(userId: "UiJ9L9CvhXgDUa19COge2C7y2RB3")
}
