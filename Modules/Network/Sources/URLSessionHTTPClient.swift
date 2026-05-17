import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let requester: HTTPRequester
    private let deserialization: NetworkDeserializable

    public convenience init() {
        self.init(
            requester: URLSessionHTTPRequester(),
            deserialization: NetworkDeserialization()
        )
    }

    init(
        requester: HTTPRequester,
        deserialization: NetworkDeserializable
    ) {
        self.requester = requester
        self.deserialization = deserialization
    }

    public func request<T: Decodable & Sendable>(
        configuration: any NetworkRequestConfigurator
    ) async throws -> T {
        let data = try await requester.request(
            baseURL: configuration.baseURL,
            path: configuration.path,
            method: configuration.method,
            query: configuration.query,
            body: configuration.body,
            headers: configuration.headers
        )
        return try deserialization.decode(data: data)
    }
}
