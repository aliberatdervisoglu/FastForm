
import Foundation

extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { // data:binary version of json(key value pair)
            return [:]
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] // as?: try, if there is an error return nil
            return json ?? [:]

        } catch {
            return [:]
        }
    }
    // guard and after try structure is same with do-catch and try
}
