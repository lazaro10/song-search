import Foundation
import Testing
@testable import SongAPI

@Suite struct SongMappingTests {
    @Test func mapsAllFieldsFromTrack() throws {
        let track = ITunesTrackFixture.make(
            trackId: 42,
            trackName: "Yesterday",
            artistName: "The Beatles",
            collectionName: "Help!",
            collectionId: 100,
            artworkUrl100: "https://example.com/art.png",
            previewUrl: "https://example.com/preview.m4a",
            trackTimeMillis: 125000
        )

        let song = try #require(Song(track: track))

        #expect(song.id == 42)
        #expect(song.name == "Yesterday")
        #expect(song.artistName == "The Beatles")
        #expect(song.albumName == "Help!")
        #expect(song.albumId == 100)
        #expect(song.artworkURL == URL(string: "https://example.com/art.png"))
        #expect(song.previewURL == URL(string: "https://example.com/preview.m4a"))
        #expect(song.duration == 125)
    }

    @Test func returnsNilWhenTrackIdMissing() {
        let track = ITunesTrackFixture.make(trackId: nil)
        #expect(Song(track: track) == nil)
    }

    @Test func returnsNilWhenTrackNameMissing() {
        let track = ITunesTrackFixture.make(trackName: nil)
        #expect(Song(track: track) == nil)
    }

    @Test func returnsNilWhenArtistNameMissing() {
        let track = ITunesTrackFixture.make(artistName: nil)
        #expect(Song(track: track) == nil)
    }

    @Test func handlesMissingOptionalFields() throws {
        let track = ITunesTrackFixture.make(
            collectionName: nil,
            collectionId: nil,
            artworkUrl100: nil,
            previewUrl: nil,
            trackTimeMillis: nil
        )

        let song = try #require(Song(track: track))

        #expect(song.albumName == nil)
        #expect(song.albumId == nil)
        #expect(song.artworkURL == nil)
        #expect(song.previewURL == nil)
        #expect(song.duration == 0)
    }
}
