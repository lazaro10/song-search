import Foundation
import Testing
@testable import SongAPI

@Suite struct AlbumMappingTests {
    @Test func mapsAllFieldsFromWrapperAndTracks() throws {
        let response = ITunesSearchResponseFixture.make(tracks: [
            ITunesTrackFixture.collectionWrapper(
                collectionId: 12345,
                collectionName: "Honky Château",
                artistName: "Elton John",
                artworkUrl100: "https://example.com/cover.png",
                releaseDate: "1973-05-19T08:00:00Z",
                trackCount: 10
            ),
            ITunesTrackFixture.make(trackId: 1, trackName: "Daniel"),
            ITunesTrackFixture.make(trackId: 2, trackName: "Honky Cat"),
        ])

        let sut = try #require(Album(from: response, collectionId: 12345))

        #expect(sut.id == 12345)
        #expect(sut.name == "Honky Château")
        #expect(sut.artistName == "Elton John")
        #expect(sut.releaseYear == 1973)
        #expect(sut.trackCount == 10)
        #expect(sut.artworkURL == URL(string: "https://example.com/cover.png"))
        #expect(sut.songs.map(\.id) == [1, 2])
    }

    @Test func returnsNilWhenNoWrapperOrFallback() {
        let response = ITunesSearchResponseFixture.make(tracks: [])
        #expect(Album(from: response, collectionId: 12345) == nil)
    }

    @Test func returnsNilWhenWrapperHasNoCollectionName() {
        let response = ITunesSearchResponseFixture.make(tracks: [
            ITunesTrackFixture.collectionWrapper(collectionName: nil),
        ])
        #expect(Album(from: response, collectionId: 12345) == nil)
    }

    @Test func fallsBackToSongsCountWhenWrapperHasNoTrackCount() throws {
        let response = ITunesSearchResponseFixture.make(tracks: [
            ITunesTrackFixture.collectionWrapper(trackCount: nil),
            ITunesTrackFixture.make(trackId: 1),
            ITunesTrackFixture.make(trackId: 2),
            ITunesTrackFixture.make(trackId: 3),
        ])

        let sut = try #require(Album(from: response, collectionId: 100))

        #expect(sut.trackCount == 3)
    }

    @Test func releaseYearIsNilWhenWrapperHasNoReleaseDate() throws {
        let response = ITunesSearchResponseFixture.make(tracks: [
            ITunesTrackFixture.collectionWrapper(releaseDate: nil),
        ])

        let sut = try #require(Album(from: response, collectionId: 100))

        #expect(sut.releaseYear == nil)
    }

    @Test func usesFirstResultAsWrapperFallbackWhenWrapperTypeMissing() throws {
        let response = ITunesSearchResponseFixture.make(tracks: [
            ITunesTrackFixture.make(
                wrapperType: nil,
                trackId: nil,
                artistName: "Artist",
                collectionName: "Album"
            ),
            ITunesTrackFixture.make(trackId: 1),
        ])

        let sut = try #require(Album(from: response, collectionId: 50))
        #expect(sut.name == "Album")
        #expect(sut.songs.map(\.id) == [1])
    }
}
