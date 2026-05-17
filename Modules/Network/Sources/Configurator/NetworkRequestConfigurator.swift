import Foundation

public protocol NetworkRequestConfigurator: Sendable {
    var baseURL: URL { get }
    var path: String { get }
    var method: NetworkMethod { get }
    var query: [String: String] { get }
    var body: Data? { get }
    var headers: [String: String] { get }
}

public extension NetworkRequestConfigurator {
    var method: NetworkMethod { .get }
    var query: [String: String] { [:] }
    var body: Data? { nil }
    var headers: [String: String] { [:] }
}
