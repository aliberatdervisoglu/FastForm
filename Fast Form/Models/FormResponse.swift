//
//  FormResponce.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//
//  It will be used to hold answers

import Foundation

struct Answer: Codable { //  needed for different question type
    let questionId: String
    var value: String?
    var selections: [String]?
    var numericValue: Double?
    var booleanValue: Bool?
}

struct FormResponce: Codable, Identifiable {
    var id = UUID().uuidString
    var formId: String
    var respondentId: String
    var answers: [Answer]
    var submittedDate: TimeInterval

}


