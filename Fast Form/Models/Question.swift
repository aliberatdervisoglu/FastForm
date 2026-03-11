//
//  Question.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 20.02.2026.
//

import Foundation

enum QuestionType: String, CaseIterable, Codable {
    case shortAnswer = "Short Answer"
    case paragraph = "Paragraph"
    //
    case multipleChoice = "Multiple Choice" //  radio
    case checkboxes = "Checkboxes" //  box
    case dropdown = "Dropdown"
    //
//    case date = "Date"
//    case time = "Time"
//    //
//    case rating = "Rating"
    case toggle = "Toggle"
}


struct Question: Identifiable, Codable {
    var id = UUID().uuidString
    var title: String
    var type: QuestionType
    var isRequired: Bool
    var options: [String] //  will be used for some QuestionType
    var maxCharactersLimit: Int = 50
}
