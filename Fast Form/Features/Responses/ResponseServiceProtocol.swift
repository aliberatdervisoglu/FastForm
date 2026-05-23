//
//  ResponseServiceProtocol.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 12.05.2026.
//

import Foundation

protocol ResponseServiceProtocol {
    func observeResponse(ownerId: String, formId: String, completion: @escaping (Result<[FormResponce], Error>) -> Void) -> Abortable
    
    func searchForms(query: String) async throws -> [FormModel]
    
    func submitResponse(ownerId: String, formId: String, response: FormResponce) async throws
}
