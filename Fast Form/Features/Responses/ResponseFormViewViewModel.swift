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
    
    init(responseService: ResponseServiceProtocol = ResponseManager()){
        self.responseService = responseService
    }
     
    func searchForms() {
        
        guard searchText.count >= 3 else {
                self.results = []
                return
            }
        
        self.isLoading = true
        
        responseService.searchForms(query: searchText) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let forms):
                    self?.results = forms
                case .failure(let error):
                    print("Search Error: \(error.localizedDescription)")
                    self?.results = []
                }
            }
        }
    }
}
