import Foundation
import Testing
@testable import SongAPI

@Suite struct LookupAlbumRequestTests {
    @Test func pathIsLookup() {
        let sut = LookupAlbumRequest(
            baseURL: URL(string: "https://example.com")!,
            collectionId: 1
        )
        #expect(sut.path == "/lookup")
    }

    @Test func queryIncludesIdAndEntitySong() {
        let sut = LookupAlbumRequest(
            baseURL: URL(string: "https://example.com")!,
            collectionId: 12345
        )
        #expect(sut.query == [
            "id": "12345",
            "entity": "song",
        ])
    }
}
