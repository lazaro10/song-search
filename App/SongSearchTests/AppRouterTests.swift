import Foundation
import Testing
import SongAPI
@testable import SongSearch

@MainActor
@Suite struct AppRouterTests {
    @Test func initialPathIsEmpty() {
        let sut = AppRouter()
        #expect(sut.path.isEmpty)
    }

    @Test func navigateAppendsRouteToPath() {
        let sut = AppRouter()
        sut.navigate(to: .album(collectionId: 42))
        #expect(sut.path == [.album(collectionId: 42)])
    }

    @Test func navigateAppendsMultipleRoutesInOrder() {
        let sut = AppRouter()
        let song = SongFixture.make(id: 1)
        sut.navigate(to: .player(song))
        sut.navigate(to: .album(collectionId: 99))
        #expect(sut.path == [.player(song), .album(collectionId: 99)])
    }
}
