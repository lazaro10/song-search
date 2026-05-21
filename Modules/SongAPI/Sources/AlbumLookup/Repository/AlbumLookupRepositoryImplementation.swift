import Foundation
import Networking
import Environment

public final class AlbumLookupRepositoryImplementation: AlbumLookupRepository {
    private let httpClient: HTTPClient
    private let environment: APIEnvironment

    public convenience init() {
        self.init(httpClient: URLSessionHTTPClient(), environment: .live)
    }

    public init(httpClient: HTTPClient, environment: APIEnvironment = .live) {
        self.httpClient = httpClient
        self.environment = environment
    }

    public func album(collectionId: Int) async throws -> Album {
        let response: ITunesSearchResponse = try await httpClient.request(
            configuration: LookupAlbumRequest(
                baseURL: environment.itunesBaseURL,
                collectionId: collectionId
            )
        )
        guard let album = Album(from: response, collectionId: collectionId) else {
            throw AlbumLookupError.albumNotFound
        }
        return album
    }
}
