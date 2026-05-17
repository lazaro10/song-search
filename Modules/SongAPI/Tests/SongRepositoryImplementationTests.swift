import Foundation
import Testing
import Network
import Environment
@testable import SongAPI

@Suite struct SongRepositoryImplementationTests {
    @Test func searchSongsBuildsSearchSongsRequestWithEnvironmentURL() async throws {
        let environment = APIEnvironment(itunesBaseURL: URL(string: "https://test.example.com")!)
        let (sut, httpClient) = makeSUT(environment: environment)
        httpClient.stubbedResult = ITunesSearchResponseFixture.make(tracks: [])

        _ = try await sut.searchSongs(term: "beatles", limit: 20, offset: 40)

        let configuration = try #require(httpClient.receivedConfigurations.first as? SearchSongsRequest)
        #expect(configuration.baseURL == URL(string: "https://test.example.com")!)
        #expect(configuration.term == "beatles")
        #expect(configuration.limit == 20)
        #expect(configuration.offset == 40)
    }

    @Test func searchSongsReturnsMappedSongs() async throws {
        let (sut, httpClient) = makeSUT()
        httpClient.stubbedResult = ITunesSearchResponseFixture.make(tracks: [
            ITunesTrackFixture.make(trackId: 1, trackName: "Yesterday"),
            ITunesTrackFixture.make(trackId: 2, trackName: "Hey Jude"),
        ])

        let songs = try await sut.searchSongs(term: "beatles", limit: 20, offset: 0)

        #expect(songs.map(\.id) == [1, 2])
        #expect(songs.map(\.name) == ["Yesterday", "Hey Jude"])
    }

    @Test func searchSongsFiltersOutNonTrackEntries() async throws {
        let (sut, httpClient) = makeSUT()
        httpClient.stubbedResult = ITunesSearchResponseFixture.make(tracks: [
            ITunesTrackFixture.make(trackId: nil, collectionId: 999),
            ITunesTrackFixture.make(trackId: 1),
        ])

        let songs = try await sut.searchSongs(term: "x", limit: 20, offset: 0)

        #expect(songs.map(\.id) == [1])
    }

    @Test func searchSongsPropagatesHTTPClientError() async {
        let (sut, httpClient) = makeSUT()
        httpClient.errorToThrow = NetworkError.httpError(statusCode: 500)

        await #expect(throws: NetworkError.httpError(statusCode: 500)) {
            _ = try await sut.searchSongs(term: "x", limit: 20, offset: 0)
        }
    }

    @Test func songsInAlbumBuildsLookupAlbumRequestWithEnvironmentURL() async throws {
        let environment = APIEnvironment(itunesBaseURL: URL(string: "https://test.example.com")!)
        let (sut, httpClient) = makeSUT(environment: environment)
        httpClient.stubbedResult = ITunesSearchResponseFixture.make(tracks: [])

        _ = try await sut.songsInAlbum(collectionId: 12345)

        let configuration = try #require(httpClient.receivedConfigurations.first as? LookupAlbumRequest)
        #expect(configuration.baseURL == URL(string: "https://test.example.com")!)
        #expect(configuration.collectionId == 12345)
    }

    @Test func songsInAlbumReturnsMappedTracksAndFiltersAlbumWrapper() async throws {
        let (sut, httpClient) = makeSUT()
        httpClient.stubbedResult = ITunesSearchResponseFixture.make(tracks: [
            ITunesTrackFixture.make(trackId: nil, collectionId: 12345),
            ITunesTrackFixture.make(trackId: 10),
            ITunesTrackFixture.make(trackId: 11),
        ])

        let songs = try await sut.songsInAlbum(collectionId: 12345)

        #expect(songs.map(\.id) == [10, 11])
    }

    @Test func songsInAlbumPropagatesHTTPClientError() async {
        let (sut, httpClient) = makeSUT()
        httpClient.errorToThrow = NetworkError.invalidResponse

        await #expect(throws: NetworkError.invalidResponse) {
            _ = try await sut.songsInAlbum(collectionId: 1)
        }
    }

    @Test func convenienceInitBuildsWithDefaultHTTPClientAndLiveEnvironment() {
        _ = SongRepositoryImplementation()
    }

    // MARK: - Helpers

    private func makeSUT(
        environment: APIEnvironment = .live
    ) -> (sut: SongRepositoryImplementation, httpClient: HTTPClientSpy) {
        let httpClient = HTTPClientSpy()
        let sut = SongRepositoryImplementation(httpClient: httpClient, environment: environment)
        return (sut, httpClient)
    }
}
