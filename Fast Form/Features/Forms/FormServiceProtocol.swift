//
//  FormServiceProtocol.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 11.05.2026.
//

import Foundation

protocol FormServiceProtocol {
    func observeForms(userId: String, completion: @escaping (Result<[FormModel], Error>) -> Void) -> ServiceCancellable?

    func deleteForm(userId: String, formId: String, completion: @escaping (Result<Void, Error>) -> Void)

    func saveForm(form: FormModel, completion: @escaping (Result<Void, Error>) -> Void)
}
