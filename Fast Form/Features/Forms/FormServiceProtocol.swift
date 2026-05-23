//
//  FormServiceProtocol.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 11.05.2026.
//

import Foundation

protocol FormServiceProtocol {
    func observeForms(userId: String, completion: @escaping (Result<[FormModel], Error>) -> Void) -> Abortable

    func deleteForm(userId: String, formId: String) async throws

    func saveForm(form: FormModel) async throws
}
