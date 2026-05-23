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

        Task {
            do {
                let incomingForms = try await responseService.searchForms(query: searchText)
                
                await MainActor.run {
                    self.results = incomingForms
                    self.isLoading = false
                }
            } catch {
                print("Search Error: /(error.localizedDescription)")
                await MainActor.run {
                    self.results = []
                    self.isLoading = false
                }
            }
        }
    }
}
