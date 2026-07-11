
import Foundation

enum ResponseManagerError: Error, Equatable {
    case invalidParameters
    case databaseError(String)
    case decodingError
    case validationFailed(questionId: String, message: String)

    var errorDescription: String {
        switch self {
        case .invalidParameters:
            "Required identifiers are missing. Please try again."
        case let .databaseError(message):
            "Database failure: \(message)"
        case .decodingError:
            "Failed to process form responses. Please contact support."
        case let .validationFailed(_, message):
            message
        }
    }
}
