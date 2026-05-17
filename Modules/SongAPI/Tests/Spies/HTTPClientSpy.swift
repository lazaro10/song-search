import Foundation
import Network

final class HTTPClientSpy: HTTPClient, @unchecked Sendable {
    private(set) var receivedConfigurations: [any NetworkRequestConfigurator] = []
    var stubbedResult: Any?
    var errorToThrow: Error?

    func request<T: Decodable & Sendable>(
        configuration: any NetworkRequestConfigurator
    ) async throws -> T {
        receivedConfigurations.append(configuration)
        if let error = errorToThrow {
            throw error
        }
        guard let result = stubbedResult as? T else {
            fatalError("HTTPClientSpy: stubbedResult not set or wrong type for \(T.self)")
        }
        return result
    }
}
