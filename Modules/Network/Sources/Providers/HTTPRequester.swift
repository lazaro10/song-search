import Foundation

protocol HTTPRequester: Sendable {
    func request(
        baseURL: URL,
        path: String,
        method: NetworkMethod,
        query: [String: String],
        body: Data?,
        headers: [String: String]
    ) async throws -> Data
}
