import Foundation
import Testing
import Networking
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

    @Test func albumBuildsLookupAlbumRequestWithEnvironmentURL() async throws {
        let environment = APIEnvironment(itunesBaseURL: URL(string: "https://test.example.com")!)
        let (sut, httpClient) = makeSUT(environment: environment)
        httpClient.stubbedResult = ITunesSearchResponseFixture.make(tracks: [
            ITunesTrackFixture.collectionWrapper(collectionId: 12345),
        ])

        _ = try await sut.album(collectionId: 12345)

        let configuration = try #require(httpClient.receivedConfigurations.first as? LookupAlbumRequest)
        #expect(configuration.baseURL == URL(string: "https://test.example.com")!)
        #expect(configuration.collectionId == 12345)
    }

    @Test func albumReturnsMappedAlbumWithMetadataAndTracks() async throws {
        let (sut, httpClient) = makeSUT()
        httpClient.stubbedResult = ITunesSearchResponseFixture.make(tracks: [
            ITunesTrackFixture.collectionWrapper(
                collectionId: 12345,
                collectionName: "Honky Château",
                artistName: "Elton John",
                releaseDate: "1973-05-19T08:00:00Z",
                trackCount: 10
            ),
            ITunesTrackFixture.make(trackId: 10, trackName: "Daniel"),
            ITunesTrackFixture.make(trackId: 11, trackName: "Honky Cat"),
        ])

        let album = try await sut.album(collectionId: 12345)

        #expect(album.id == 12345)
        #expect(album.name == "Honky Château")
        #expect(album.releaseYear == 1973)
        #expect(album.trackCount == 10)
        #expect(album.songs.map(\.id) == [10, 11])
    }

    @Test func albumThrowsAlbumNotFoundWhenWrapperCannotBeMapped() async {
        let (sut, httpClient) = makeSUT()
        httpClient.stubbedResult = ITunesSearchResponseFixture.make(tracks: [])

        await #expect(throws: SongRepositoryError.albumNotFound) {
            _ = try await sut.album(collectionId: 1)
        }
    }

    @Test func albumPropagatesHTTPClientError() async {
        let (sut, httpClient) = makeSUT()
        httpClient.errorToThrow = NetworkError.invalidResponse

        await #expect(throws: NetworkError.invalidResponse) {
            _ = try await sut.album(collectionId: 1)
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
