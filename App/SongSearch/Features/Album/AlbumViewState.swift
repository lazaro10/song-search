import SongAPI

enum AlbumViewState: Equatable {
    case idle
    case loading
    case content(album: Album)
    case empty
    case error(message: String)
}
