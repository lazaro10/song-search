import Foundation

public struct Album: Sendable, Equatable, Hashable, Identifiable {
    public let id: Int
    public let name: String
    public let artistName: String
    public let releaseYear: Int?
    public let trackCount: Int
    public let artworkURL: URL?
    public let songs: [Song]

    public init(
        id: Int,
        name: String,
        artistName: String,
        releaseYear: Int?,
        trackCount: Int,
        artworkURL: URL?,
        songs: [Song]
    ) {
        self.id = id
        self.name = name
        self.artistName = artistName
        self.releaseYear = releaseYear
        self.trackCount = trackCount
        self.artworkURL = artworkURL
        self.songs = songs
    }
}

extension Album {
    init?(from response: ITunesSearchResponse, collectionId: Int) {
        let collectionWrapper: ITunesTrack? = response.results.first(where: { $0.wrapperType == "collection" })
        let fallbackWrapper: ITunesTrack? = response.results.first(where: { $0.trackId == nil })
        guard
            let wrapper = collectionWrapper ?? fallbackWrapper,
            let name = wrapper.collectionName,
            let artistName = wrapper.artistName
        else {
            return nil
        }

        let songs = response.results.compactMap(Song.init(track:))

        self.init(
            id: collectionId,
            name: name,
            artistName: artistName,
            releaseYear: wrapper.releaseDate.flatMap { Int($0.prefix(4)) },
            trackCount: wrapper.trackCount ?? songs.count,
            artworkURL: wrapper.artworkUrl100.flatMap(URL.init(string:)),
            songs: songs
        )
    }
}
