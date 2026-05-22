//
//  ResponseFormViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation

@Observable
class ResponseFormViewViewModel {
    var searchText: String = ""
    var results: [FormModel] = []
    var isLoading: Bool = false

    private let responseService: ResponseServiceProtocol

    init(responseService: ResponseServiceProtocol = ResponseManager()) {
        self.responseService = responseService
    }

    func searchForms() {
        guard searchText.count >= 3 else {
            results = []
            return
        }

        isLoading = true

        responseService.searchForms(query: searchText) { @MainActor [weak self] result in
            self?.isLoading = false

            switch result {
            case let .success(forms):
                self?.results = forms
            case let .failure(error):
                print("Search Error: \(error.localizedDescription)")
                self?.results = []
            }
        }
    }
}
