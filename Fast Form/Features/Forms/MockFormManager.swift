//
//  MockFormManager.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.06.2026.
//

import Foundation

class MockFormManager: FormManager {
    private var mockForms: [FormModel] = [
        FormModel(
            id: UUID().uuidString,
            title: "Customer Feedback",
            ownerId: "mock_user_123",
            explanation: "Please tell us about your experience.",
            questionList: [],
            createDate: Date().timeIntervalSince1970,
            isAnonymus: true
        ), FormModel(
            id: "form_999",
            title: "Team Lunch Voting",
            ownerId: "mock_user_123",
            explanation: "Vote for what we should eat this Friday!",
            questionList: [],
            createDate: Date().timeIntervalSince1970,
            isAnonymus: false
        ),
    ]

    // MARK: - Initalizer

    init() {
        print("🛠️ MockFormManager Initialized - Using Fake Data")
    }

    // MARK: - Mocked Functions

    func observeForms(userId _: String, completion: @escaping (Result<[FormModel], FormManagerError>) -> Void) -> Abortable {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(self.mockForms))
        }

        return AnyAbortable {
            print("Mock Listener removed")
        }
    }

    func deleteForm(userId _: String, formId: String) async throws(FormManagerError) {
        try? await Task.sleep(nanoseconds: 500_000_000)

        mockForms.removeAll { $0.id == formId }
        print("🗑️ Mock: Successfully deleted form \(formId)")
    }

    func saveForm(form: FormModel) async throws(FormManagerError) {
        try? await Task.sleep(nanoseconds: 500_000_000)

        var newForm = form
        newForm.ownerId = "mock_user_123"
        mockForms.append(newForm)
        print("Mock: Successfully saved form \(newForm.id)")
    }
}
