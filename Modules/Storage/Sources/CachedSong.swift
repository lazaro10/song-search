import Foundation
import SwiftData
import SongAPI

@Model
final class CachedSong {
    @Attribute(.unique) var id: Int
    var name: String
    var artistName: String
    var albumName: String?
    var albumId: Int?
    var artworkURLString: String?
    var previewURLString: String?
    var duration: TimeInterval
    var playedAt: Date

    init(
        id: Int,
        name: String,
        artistName: String,
        albumName: String?,
        albumId: Int?,
        artworkURLString: String?,
        previewURLString: String?,
        duration: TimeInterval,
        playedAt: Date
    ) {
        self.id = id
        self.name = name
        self.artistName = artistName
        self.albumName = albumName
        self.albumId = albumId
        self.artworkURLString = artworkURLString
        self.previewURLString = previewURLString
        self.duration = duration
        self.playedAt = playedAt
    }
}

extension CachedSong {
    convenience init(from song: Song, playedAt: Date = .now) {
        self.init(
            id: song.id,
            name: song.name,
            artistName: song.artistName,
            albumName: song.albumName,
            albumId: song.albumId,
            artworkURLString: song.artworkURL?.absoluteString,
            previewURLString: song.previewURL?.absoluteString,
            duration: song.duration,
            playedAt: playedAt
        )
    }

    var asSong: Song {
        Song(
            id: id,
            name: name,
            artistName: artistName,
            albumName: albumName,
            albumId: albumId,
            artworkURL: artworkURLString.flatMap { URL(string: $0) },
            previewURL: previewURLString.flatMap { URL(string: $0) },
            duration: duration
        )
    }
}
