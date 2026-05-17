import Foundation
@testable import Network

final class NetworkDeserializableSpy: NetworkDeserializable, @unchecked Sendable {
    private(set) var receivedData: [Data] = []
    var stubbedResult: Any?
    var errorToThrow: Error?

    func decode<T: Decodable>(data: Data) throws -> T {
        receivedData.append(data)
        if let error = errorToThrow {
            throw error
        }
        guard let result = stubbedResult as? T else {
            fatalError("NetworkDeserializableSpy: stubbedResult not set or wrong type for \(T.self)")
        }
        return result
    }
}
