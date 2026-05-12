//
//  FormModel.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//
//  It will be used to hold title, explanation and question list of form.

import Foundation

struct FormModel: Identifiable, Codable {
    var id = UUID().uuidString
    var title: String
    var ownerId: String
    var explanation: String
    var questionList: [Question]
    var createDate: TimeInterval
    var isAnonymus: Bool
}
