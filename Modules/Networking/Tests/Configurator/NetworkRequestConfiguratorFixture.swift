import Foundation
@testable import Networking

enum NetworkRequestConfiguratorFixture {
    static func make(
        baseURL: URL = URL(string: "https://api.example.com")!,
        path: String = "/v1/test",
        method: NetworkMethod = .get,
        query: [String: String] = [:],
        body: Data? = nil,
        headers: [String: String] = [:]
    ) -> some NetworkRequestConfigurator {
        Configurator(
            baseURL: baseURL,
            path: path,
            method: method,
            query: query,
            body: body,
            headers: headers
        )
    }

    private struct Configurator: NetworkRequestConfigurator {
        let baseURL: URL
        let path: String
        let method: NetworkMethod
        let query: [String: String]
        let body: Data?
        let headers: [String: String]
    }
}
