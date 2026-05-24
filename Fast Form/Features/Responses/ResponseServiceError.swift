//
//  ResponseServiceError.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 24.05.2026.
//

import Foundation

enum ResponseServiceError: Error, Equatable {
    case invalidParameters
    case databaseError(String)
    case decodingError
    case validationFailed(String)

    var errorDescription: String {
        switch self {
        case .invalidParameters:
            "Required identifiers are missing. Please try again."
        case let .databaseError(message):
            "Database failure: \(message)"
        case .decodingError:
            "Failed to process form responses. Please contact support."
        case let .validationFailed(message):
            message
        }
    }
}
