import Foundation

public enum NetworkError: Error, Equatable, Sendable {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
}
