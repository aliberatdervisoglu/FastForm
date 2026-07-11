
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
