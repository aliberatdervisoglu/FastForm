//
//  FormServiceError.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 24.05.2026.
//

import Foundation

enum FormServiceError: Error, Equatable {
    case userNotFound
    case databaseError(String)
    case decodingError
    case unknown(String)

    var errorDescription: String {
        switch self {
        case .userNotFound:
            "Active user session not found. Please log in again"
        case let .databaseError(error):
            "Database failue: \(error)"
        case .decodingError:
            "Failed to process form data. Please contact support."
        case let .unknown(error):
            "Unknown error: \(error)"
        }
    }
}
