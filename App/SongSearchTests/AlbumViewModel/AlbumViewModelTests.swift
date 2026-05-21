import Foundation
import Testing
import SongAPI
@testable import SongSearch

@MainActor
@Suite struct AlbumViewModelTests {
    @Test func initialStateIsIdle() {
        let (sut, _) = makeSUT()
        #expect(sut.state == .idle)
    }

    @Test func startLoadsAlbumAndEntersContentState() async {
        let (sut, repo) = makeSUT()
        let album = AlbumFixture.make(id: 12345)
        repo.stubbedAlbum = album

        await sut.start()

        #expect(repo.albumCalls == [42])
        #expect(sut.state == .content(album: album))
    }

    @Test func startEntersEmptyStateWhenAlbumHasNoSongs() async {
        let (sut, repo) = makeSUT()
        repo.stubbedAlbum = AlbumFixture.make(songs: [])

        await sut.start()

        #expect(sut.state == .empty)
    }

    @Test func startEntersErrorStateOnFailure() async {
        let (sut, repo) = makeSUT()
        repo.errorToThrow = SampleError.network

        await sut.start()

        if case let .error(message) = sut.state {
            #expect(message == SampleError.network.localizedDescription)
        } else {
            Issue.record("Expected .error, got \(sut.state)")
        }
    }

    @Test func startCanBeCalledAgainToRetryAfterFailure() async {
        let (sut, repo) = makeSUT()
        repo.errorToThrow = SampleError.network
        await sut.start()
        if case .error = sut.state {} else {
            Issue.record("Expected .error, got \(sut.state)")
        }

        repo.errorToThrow = nil
        repo.stubbedAlbum = AlbumFixture.make(id: 42)
        await sut.start()

        if case .content = sut.state {} else {
            Issue.record("Expected .content after retry, got \(sut.state)")
        }
        #expect(repo.albumCalls == [42, 42])
    }

    private func makeSUT() -> (sut: AlbumViewModel, repository: AlbumLookupRepositorySpy) {
        let repo = AlbumLookupRepositorySpy()
        let sut = AlbumViewModel(collectionId: 42, albumLookupRepository: repo)
        return (sut, repo)
    }
}

private enum SampleError: Error, LocalizedError {
    case network
    var errorDescription: String? { "Sample network error" }
}
