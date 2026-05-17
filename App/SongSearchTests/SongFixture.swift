import Foundation
import SongAPI

enum SongFixture {
    static func make(
        id: Int = 1,
        name: String = "Sample Song",
        artistName: String = "Sample Artist",
        albumName: String? = "Sample Album",
        albumId: Int? = 100,
        artworkURL: URL? = URL(string: "https://example.com/art.png"),
        previewURL: URL? = nil,
        duration: TimeInterval = 180
    ) -> Song {
        Song(
            id: id,
            name: name,
            artistName: artistName,
            albumName: albumName,
            albumId: albumId,
            artworkURL: artworkURL,
            previewURL: previewURL,
            duration: duration
        )
    }
}
