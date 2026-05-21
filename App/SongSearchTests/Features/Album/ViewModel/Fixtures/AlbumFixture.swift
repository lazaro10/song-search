import Foundation
import SongAPI

enum AlbumFixture {
    static func make(
        id: Int = 100,
        name: String = "Sample Album",
        artistName: String = "Sample Artist",
        releaseYear: Int? = 2024,
        trackCount: Int = 3,
        artworkURL: URL? = URL(string: "https://example.com/album.png"),
        songs: [Song] = [
            SongFixture.make(id: 1, name: "Track One"),
            SongFixture.make(id: 2, name: "Track Two"),
            SongFixture.make(id: 3, name: "Track Three"),
        ]
    ) -> Album {
        Album(
            id: id,
            name: name,
            artistName: artistName,
            releaseYear: releaseYear,
            trackCount: trackCount,
            artworkURL: artworkURL,
            songs: songs
        )
    }
}
