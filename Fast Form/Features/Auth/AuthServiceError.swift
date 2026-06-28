//
//  AuthServiceError.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 11.05.2026.
//

import Foundation

enum AuthServiceError: Error, Equatable {
    case userNotFound
    case requiresRecentLogin
    case ivalidEmailOrPassword
    case emailAlreadyInUse
    case weakPassword
    case databaseError(String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "No authenticated user found to perform this operation."
        case .requiresRecentLogin:
            "This operation is sensitive and requires a recent login. Please log in again before retrying."
        case .ivalidEmailOrPassword:
            "Invalid email or password. Please try again."
        case .emailAlreadyInUse:
            "The email address you provided is already in use."
        case .weakPassword:
            "The password must be at least 6 characters long."
        case let .databaseError(message):
            "Database failure: \(message)."
        case let .unknown(message):
            "\(message)"
        }
    }
}
