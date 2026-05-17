import Foundation

protocol NetworkDeserializable: Sendable {
    func decode<T: Decodable>(data: Data) throws -> T
}
