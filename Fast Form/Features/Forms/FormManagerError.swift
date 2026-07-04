
import Foundation

enum FormManagerError: Error, Equatable {
    case userNotFound
    case databaseError(String)
    case decodingError
    case titleTooShort
    case questionTitleTooShort
    case unknown(String)

    var errorDescription: String {
        switch self {
        case .userNotFound:
            "Active user session not found. Please log in again"
        case let .databaseError(error):
            "Database failue: \(error)"
        case .decodingError:
            "Failed to process form data. Please contact support."
        case .titleTooShort:
            "Form title is too short! It must be at least 3 characters."
        case .questionTitleTooShort: // 🎯 ADD THIS MESSAGE
            "One or more of your questions are too short! Every question needs a valid title."
        case let .unknown(error):
            "Unknown error: \(error)"
        }
    }
}
