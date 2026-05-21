import Foundation
import Testing
import Networking
import Environment
@testable import SongAPI

@Suite struct AlbumLookupRepositoryImplementationTests {
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

        await #expect(throws: AlbumLookupError.albumNotFound) {
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
        _ = AlbumLookupRepositoryImplementation()
    }

    // MARK: - Helpers

    private func makeSUT(
        environment: APIEnvironment = .live
    ) -> (sut: AlbumLookupRepositoryImplementation, httpClient: HTTPClientSpy) {
        let httpClient = HTTPClientSpy()
        let sut = AlbumLookupRepositoryImplementation(httpClient: httpClient, environment: environment)
        return (sut, httpClient)
    }
}
