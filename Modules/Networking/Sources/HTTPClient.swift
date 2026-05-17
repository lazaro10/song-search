import Foundation

public protocol HTTPClient: Sendable {
    func request<T: Decodable & Sendable>(
        configuration: any NetworkRequestConfigurator
    ) async throws -> T
}
