import Foundation
@testable import SongAPI

enum ITunesTrackFixture {
    static func make(
        trackId: Int? = 1,
        trackName: String? = "Sample Song",
        artistName: String? = "Sample Artist",
        collectionName: String? = "Sample Album",
        collectionId: Int? = 100,
        artworkUrl100: String? = "https://example.com/art.png",
        previewUrl: String? = "https://example.com/preview.m4a",
        trackTimeMillis: Int? = 180000
    ) -> ITunesTrack {
        ITunesTrack(
            trackId: trackId,
            trackName: trackName,
            artistName: artistName,
            collectionName: collectionName,
            collectionId: collectionId,
            artworkUrl100: artworkUrl100,
            previewUrl: previewUrl,
            trackTimeMillis: trackTimeMillis
        )
    }
}
