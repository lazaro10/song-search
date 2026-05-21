import Foundation
import SongAPI

enum SongFixture {
    static func make(
        id: Int = 1,
        name: String = "Yesterday",
        artistName: String = "The Beatles",
        albumName: String? = "Help!",
        albumId: Int? = 100,
        artworkURL: URL? = nil,
        previewURL: URL? = nil,
        duration: TimeInterval = 225
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

enum AlbumFixture {
    static func make(
        id: Int = 100,
        name: String = "Honky Château",
        artistName: String = "Elton John",
        releaseYear: Int? = 1972,
        trackCount: Int = 10,
        songs: [Song] = [
            SongFixture.make(id: 10, name: "Honky Cat", duration: 312),
            SongFixture.make(id: 11, name: "Mellow", duration: 332),
            SongFixture.make(id: 12, name: "I Think I\u{2019}m Going to Kill Myself", duration: 215),
            SongFixture.make(id: 13, name: "Susie (Dramas)", duration: 211),
            SongFixture.make(id: 14, name: "Rocket Man", duration: 256),
        ]
    ) -> Album {
        Album(
            id: id,
            name: name,
            artistName: artistName,
            releaseYear: releaseYear,
            trackCount: trackCount,
            artworkURL: nil,
            songs: songs
        )
    }
}
