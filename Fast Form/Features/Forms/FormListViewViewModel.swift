//
//  FormListViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 22.02.2026.
//

import Foundation

enum FormSortOption: String, CaseIterable { //  Sort options for formlist
    case newest = "Newest First"
    case oldest = "Oldest First"
    case aToZ = "A - Z"
    case zToA = "Z - A"
}

@Observable
class FormListViewViewModel {
    var formitems: [FormModel] = []
    var sortOption: FormSortOption = .newest //  it is published an if it is changed, all modules run again like 'sortedForms'

    private let userId: String
    private var formService: FormServiceProtocol
    private var formAbortable: Abortable?

    var sortedforms: [FormModel] { // works about current sort option and resort the forms.
        switch sortOption {
        case .newest:
            formitems.sorted { $0.createDate > $1.createDate }
        case .oldest:
            formitems.sorted { $0.createDate < $1.createDate }
        case .aToZ:
            formitems.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .zToA:
            formitems.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedDescending }
        }
    }

    init(userId: String, formService: FormServiceProtocol = FormManager()) {
        self.userId = userId
        self.formService = formService
    }

    func fetchForms() {
        formAbortable?.cancel()

        formAbortable = formService.observeForms(userId: userId) { @MainActor [weak self] result in
            switch result {
            case let .success(forms):
                self?.formitems = forms
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func deleteForm(id: String) {
        formService.deleteForm(userId: userId, formId: id) { result in
            switch result {
            case .success:
                print("Success deletion form!")
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    deinit {
        formAbortable?.cancel()
    }
}
