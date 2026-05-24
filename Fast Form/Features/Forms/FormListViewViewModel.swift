//
//  FormListViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 22.02.2026.
//

import Foundation

//  MARK: - Sort options for formlist

enum FormSortOption: String, CaseIterable {
    case newest = "Newest First"
    case oldest = "Oldest First"
    case aToZ = "A - Z"
    case zToA = "Z - A"
}

@Observable
class FormListViewViewModel {
    // MARK: - Properties

    var formitems: [FormModel] = []
    var sortOption: FormSortOption = .newest //  it is published an if it is changed, all modules run again like 'sortedForms'
    var errorMessage: String = ""

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

    // MARK: - Init

    init(userId: String, formService: FormServiceProtocol = FormManager()) {
        self.userId = userId
        self.formService = formService
    }

    // MARK: - Public Functions

    func fetchForms() {
        formAbortable?.cancel()
        errorMessage = ""

        formAbortable = formService.observeForms(userId: userId) { @MainActor [weak self] result in
            switch result {
            case let .success(forms):
                self?.formitems = forms
            case let .failure(error):
                self?.errorMessage = error.errorDescription
            }
        }
    }

    func deleteForm(id: String) {
        errorMessage = ""
        Task {
            do {
                try await formService.deleteForm(userId: userId, formId: id)
            } catch let error as FormServiceError {
                await MainActor.run {
                    self.errorMessage = error.errorDescription
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // MARK: - Lifecycle

    deinit {
        formAbortable?.cancel()
    }
}
