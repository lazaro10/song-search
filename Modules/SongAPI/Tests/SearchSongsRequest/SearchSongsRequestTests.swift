import Foundation
import Testing
@testable import SongAPI

@Suite struct SearchSongsRequestTests {
    @Test func pathIsSearch() {
        let sut = SearchSongsRequest(
            baseURL: URL(string: "https://example.com")!,
            term: "x",
            limit: 20,
            offset: 0
        )
        #expect(sut.path == "/search")
    }

    @Test func queryIncludesTermMediaEntityLimitOffset() {
        let sut = SearchSongsRequest(
            baseURL: URL(string: "https://example.com")!,
            term: "beatles",
            limit: 25,
            offset: 50
        )
        #expect(sut.query == [
            "term": "beatles",
            "media": "music",
            "entity": "song",
            "limit": "25",
            "offset": "50",
        ])
    }
}
