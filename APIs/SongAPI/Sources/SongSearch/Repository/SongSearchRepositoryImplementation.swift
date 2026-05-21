import Foundation
import Networking
import Environment

public final class SongSearchRepositoryImplementation: SongSearchRepository {
    private let httpClient: HTTPClient
    private let environment: APIEnvironment

    public convenience init() {
        self.init(httpClient: URLSessionHTTPClient(), environment: .live)
    }

    public init(httpClient: HTTPClient, environment: APIEnvironment = .live) {
        self.httpClient = httpClient
        self.environment = environment
    }

    public func searchSongs(term: String, limit: Int, offset: Int) async throws -> [Song] {
        let response: ITunesSearchResponse = try await httpClient.request(
            configuration: SearchSongsRequest(
                baseURL: environment.itunesBaseURL,
                term: term,
                limit: limit,
                offset: offset
            )
        )
        return response.results.compactMap(Song.init(track:))
    }
}
