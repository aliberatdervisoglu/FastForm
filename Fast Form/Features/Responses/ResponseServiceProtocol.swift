//
//  ResponseServiceProtocol.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 12.05.2026.
//

import Foundation

protocol ResponseServiceProtocol {
    
    func observeResponse(ownerId: String, formId: String, completion: @escaping (Result<[FormResponce], Error>) -> Void) -> ServiceCancellable?
    
    func searchForms(query: String, completion: @escaping (Result<[FormModel], Error>) -> Void)
    
    func submitResponse(ownerId: String, formId: String, response: FormResponce, completion: @escaping (Result<Void, Error>) -> Void)
}
