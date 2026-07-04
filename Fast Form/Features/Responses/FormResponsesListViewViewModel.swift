//
//  FormResponsesListViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 21.03.2026.
//

import Foundation

@Observable
class FormResponsesListViewViewModel {
    // MARK: - Properties

    @MainActor var responses: [FormResponse] = []
    @MainActor var isLoading = false
    @MainActor var errorMessage: String = ""

    private let responseService: ResponseManager
    private var responseAbortable: Abortable?

    // MARK: - Init

    init(responseService: ResponseManager = ResponseManagerImpl()) {
        self.responseService = responseService
    }

    // MARK: - Public Functions

    @MainActor
    func fetchResponses(ownerId: String, formId: String) {
        isLoading = true
        errorMessage = ""

        responseAbortable?.cancel()

        responseAbortable = responseService.observeResponse(ownerId: ownerId, formId: formId) { @MainActor [weak self] result in
            guard let self else { return }

            isLoading = false

            switch result {
            case let .success(fetchedResponses):
                responses = fetchedResponses
            case let .failure(error):
                errorMessage = error.errorDescription
                responses = []
            }
        }
    }

    // MARK: - Lifecycle

    deinit {
        responseAbortable?.cancel()
    }
}
