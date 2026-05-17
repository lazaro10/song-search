import Foundation
import SwiftData
import SongAPI

@Model
final class CachedAlbum {
    @Attribute(.unique) var id: Int
    var name: String
    var artistName: String
    var releaseYear: Int?
    var trackCount: Int
    var artworkURLString: String?
    var songsJSON: Data
    var fetchedAt: Date

    init(
        id: Int,
        name: String,
        artistName: String,
        releaseYear: Int?,
        trackCount: Int,
        artworkURLString: String?,
        songsJSON: Data,
        fetchedAt: Date
    ) {
        self.id = id
        self.name = name
        self.artistName = artistName
        self.releaseYear = releaseYear
        self.trackCount = trackCount
        self.artworkURLString = artworkURLString
        self.songsJSON = songsJSON
        self.fetchedAt = fetchedAt
    }
}

extension CachedAlbum {
    convenience init(from album: Album, fetchedAt: Date = .now) {
        self.init(
            id: album.id,
            name: album.name,
            artistName: album.artistName,
            releaseYear: album.releaseYear,
            trackCount: album.trackCount,
            artworkURLString: album.artworkURL?.absoluteString,
            songsJSON: (try? JSONEncoder().encode(album.songs)) ?? Data(),
            fetchedAt: fetchedAt
        )
    }

    func update(from album: Album) {
        name = album.name
        artistName = album.artistName
        releaseYear = album.releaseYear
        trackCount = album.trackCount
        artworkURLString = album.artworkURL?.absoluteString
        songsJSON = (try? JSONEncoder().encode(album.songs)) ?? Data()
        fetchedAt = .now
    }

    func toAlbum() -> Album? {
        guard let songs = try? JSONDecoder().decode([Song].self, from: songsJSON) else { return nil }
        return Album(
            id: id,
            name: name,
            artistName: artistName,
            releaseYear: releaseYear,
            trackCount: trackCount,
            artworkURL: artworkURLString.flatMap(URL.init(string:)),
            songs: songs
        )
    }
}
