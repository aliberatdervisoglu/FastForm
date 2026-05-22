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
    private var responseCancellable: ServiceCancellable?
    
    init(responseService: ResponseServiceProtocol = ResponseManager()){
        self.responseService = responseService
    }
    func fetchResponses(ownerId: String, formId: String) {
        isLoading = true
        
        responseCancellable?.cancel()
        
        responseCancellable = responseService.observeResponse(ownerId: ownerId, formId: formId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedResponses):
                    self?.responses = fetchedResponses
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    deinit {
        responseCancellable?.cancel()
    }
}
