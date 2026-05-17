import Foundation

public struct APIEnvironment: Sendable, Equatable {
    public let itunesBaseURL: URL

    public init(itunesBaseURL: URL) {
        self.itunesBaseURL = itunesBaseURL
    }
}

public extension APIEnvironment {
    static let live = APIEnvironment(
        itunesBaseURL: URL(string: "https://itunes.apple.com")!
    )
}
