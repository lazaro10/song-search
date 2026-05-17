import SongAPI

enum AlbumViewState: Equatable {
    case idle
    case loading
    case content(songs: [Song])
    case empty
    case error(message: String)
}
