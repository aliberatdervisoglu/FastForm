//
//  FormResponsesListViewViewModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 21.03.2026.
//

import Foundation

@Observable
class FormResponsesListViewViewModel {
    var responses: [FormResponce] = []
    var isLoading = false

    private let responseService: ResponseServiceProtocol
    private var responseAbortable: Abortable?

    init(responseService: ResponseServiceProtocol = ResponseManager()) {
        self.responseService = responseService
    }

    func fetchResponses(ownerId: String, formId: String) {
        isLoading = true

        responseAbortable?.cancel()

        responseAbortable = responseService.observeResponse(ownerId: ownerId, formId: formId) { @MainActor [weak self] result in
            self?.isLoading = false
            switch result {
            case let .success(fetchedResponses):
                self?.responses = fetchedResponses
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
            
        }
    }

    deinit {
        responseAbortable?.cancel()
    }
}
