//
//  FormServiceProtocol.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 11.05.2026.
//

import Foundation

protocol FormManager {
    // MARK: - Public / Internal Functions (Accessible from ViewModels)

    func observeForms(userId: String, completion: @escaping (Result<[FormModel], FormManagerError>) -> Void) -> Abortable

    func deleteForm(userId: String, formId: String) async throws(FormManagerError)

    func saveForm(form: FormModel) async throws(FormManagerError)
}
