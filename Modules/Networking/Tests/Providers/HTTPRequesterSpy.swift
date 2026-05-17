import Foundation
@testable import Networking

final class HTTPRequesterSpy: HTTPRequester, @unchecked Sendable {
    struct Call: Equatable {
        let baseURL: URL
        let path: String
        let method: NetworkMethod
        let query: [String: String]
        let body: Data?
        let headers: [String: String]
    }

    private(set) var calls: [Call] = []
    var stubbedData: Data = Data()
    var errorToThrow: Error?

    func request(
        baseURL: URL,
        path: String,
        method: NetworkMethod,
        query: [String: String],
        body: Data?,
        headers: [String: String]
    ) async throws -> Data {
        calls.append(Call(
            baseURL: baseURL,
            path: path,
            method: method,
            query: query,
            body: body,
            headers: headers
        ))
        if let error = errorToThrow {
            throw error
        }
        return stubbedData
    }
}
