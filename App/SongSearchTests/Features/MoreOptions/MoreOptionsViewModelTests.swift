import Foundation
import Testing
import SongAPI
@testable import SongSearch

@MainActor
@Suite struct MoreOptionsViewModelTests {
    @Test func canViewAlbumIsTrueWhenAlbumIdIsSet() {
        let sut = makeSUT(song: SongFixture.make(albumId: 100))
        #expect(sut.canViewAlbum == true)
    }

    @Test func canViewAlbumIsFalseWhenAlbumIdIsNil() {
        let sut = makeSUT(song: SongFixture.make(albumId: nil))
        #expect(sut.canViewAlbum == false)
    }

    @Test func shareMessageFormatsNameAndArtist() {
        let sut = makeSUT(song: SongFixture.make(name: "Daniel", artistName: "Elton John"))
        #expect(sut.shareMessage == "Check out Daniel by Elton John")
    }

    @Test func addToRecentlyPlayedForwardsSongToRepository() async {
        let song = SongFixture.make(id: 42, name: "Daniel")
        let repo = RecentlyPlayedRepositorySpy()
        let sut = MoreOptionsViewModel(song: song, recentlyPlayedRepository: repo)

        await sut.addToRecentlyPlayed()

        #expect(repo.addCalls.map(\.id) == [42])
    }

    // MARK: - Helpers

    private func makeSUT(song: Song) -> MoreOptionsViewModel {
        MoreOptionsViewModel(song: song, recentlyPlayedRepository: RecentlyPlayedRepositorySpy())
    }
}
