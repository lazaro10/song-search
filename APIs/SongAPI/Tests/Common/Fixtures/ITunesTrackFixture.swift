import Foundation
@testable import SongAPI

enum ITunesTrackFixture {
    static func make(
        wrapperType: String? = "track",
        trackId: Int? = 1,
        trackName: String? = "Sample Song",
        artistName: String? = "Sample Artist",
        collectionName: String? = "Sample Album",
        collectionId: Int? = 100,
        artworkUrl100: String? = "https://example.com/art.png",
        previewUrl: String? = "https://example.com/preview.m4a",
        trackTimeMillis: Int? = 180000,
        releaseDate: String? = nil,
        trackCount: Int? = nil
    ) -> ITunesTrack {
        ITunesTrack(
            wrapperType: wrapperType,
            trackId: trackId,
            trackName: trackName,
            artistName: artistName,
            collectionName: collectionName,
            collectionId: collectionId,
            artworkUrl100: artworkUrl100,
            previewUrl: previewUrl,
            trackTimeMillis: trackTimeMillis,
            releaseDate: releaseDate,
            trackCount: trackCount
        )
    }

    static func collectionWrapper(
        collectionId: Int = 100,
        collectionName: String? = "Sample Album",
        artistName: String? = "Sample Artist",
        artworkUrl100: String? = "https://example.com/art.png",
        releaseDate: String? = "2024-05-17T08:00:00Z",
        trackCount: Int? = 10
    ) -> ITunesTrack {
        ITunesTrack(
            wrapperType: "collection",
            trackId: nil,
            trackName: nil,
            artistName: artistName,
            collectionName: collectionName,
            collectionId: collectionId,
            artworkUrl100: artworkUrl100,
            previewUrl: nil,
            trackTimeMillis: nil,
            releaseDate: releaseDate,
            trackCount: trackCount
        )
    }
}
