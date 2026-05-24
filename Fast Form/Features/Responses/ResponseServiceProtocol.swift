//
//  ResponseServiceProtocol.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 12.05.2026.
//

import Foundation

protocol ResponseServiceProtocol {
    // MARK: - Public / Internal Functions (Accessible from ViewModels)

    func observeResponse(ownerId: String, formId: String, completion: @escaping (Result<[FormResponse], Error>) -> Void) -> Abortable

    func searchForms(query: String) async throws -> [FormModel]

    func submitResponse(ownerId: String, formId: String, response: FormResponse) async throws
}
