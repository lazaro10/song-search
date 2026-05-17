import Foundation

struct DecodableFixture: Decodable, Equatable, Sendable {
    let id: Int
    let name: String
}
