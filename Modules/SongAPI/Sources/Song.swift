import Foundation

public struct Song: Sendable, Equatable, Hashable, Identifiable {
    public let id: Int
    public let name: String
    public let artistName: String
    public let albumName: String?
    public let albumId: Int?
    public let artworkURL: URL?
    public let previewURL: URL?
    public let duration: TimeInterval

    public init(
        id: Int,
        name: String,
        artistName: String,
        albumName: String?,
        albumId: Int?,
        artworkURL: URL?,
        previewURL: URL?,
        duration: TimeInterval
    ) {
        self.id = id
        self.name = name
        self.artistName = artistName
        self.albumName = albumName
        self.albumId = albumId
        self.artworkURL = artworkURL
        self.previewURL = previewURL
        self.duration = duration
    }
}

extension Song {
    init?(track: ITunesTrack) {
        guard
            let id = track.trackId,
            let name = track.trackName,
            let artistName = track.artistName
        else { return nil }

        self.init(
            id: id,
            name: name,
            artistName: artistName,
            albumName: track.collectionName,
            albumId: track.collectionId,
            artworkURL: track.artworkUrl100.flatMap(URL.init(string:)),
            previewURL: track.previewUrl.flatMap(URL.init(string:)),
            duration: TimeInterval(track.trackTimeMillis ?? 0) / 1000
        )
    }
}
