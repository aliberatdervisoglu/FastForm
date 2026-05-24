//
//  ResponseFormViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation

@Observable
class ResponseFormViewViewModel {
    // MARK: - Properties

    @MainActor var searchText: String = ""
    @MainActor var results: [FormModel] = []
    @MainActor var isLoading: Bool = false

    private let responseService: ResponseServiceProtocol

    // MARK: - Init

    init(responseService: ResponseServiceProtocol = ResponseManager()) {
        self.responseService = responseService
    }

    // MARK: - Public Functions
    @MainActor
    func searchForms() async throws(ResponseServiceError) {
        guard searchText.count >= 3 else {
            results = []
            return
        }

        isLoading = true
        
        defer {
            isLoading = false
        }

        do {
            results = try await responseService.searchForms(query: searchText)
        } catch {
            results = []
            throw error
        }
    }
}
