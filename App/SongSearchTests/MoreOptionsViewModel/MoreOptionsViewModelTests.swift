import Foundation
import Testing
import SongAPI
@testable import SongSearch

@MainActor
@Suite struct MoreOptionsViewModelTests {
    @Test func canViewAlbumIsTrueWhenAlbumIdIsSet() {
        let sut = MoreOptionsViewModel(song: SongFixture.make(albumId: 100))
        #expect(sut.canViewAlbum == true)
    }

    @Test func canViewAlbumIsFalseWhenAlbumIdIsNil() {
        let sut = MoreOptionsViewModel(song: SongFixture.make(albumId: nil))
        #expect(sut.canViewAlbum == false)
    }

    @Test func shareMessageFormatsNameAndArtist() {
        let sut = MoreOptionsViewModel(song: SongFixture.make(name: "Daniel", artistName: "Elton John"))
        #expect(sut.shareMessage == "Check out Daniel by Elton John")
    }
}
