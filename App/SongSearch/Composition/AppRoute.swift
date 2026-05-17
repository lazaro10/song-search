import SongAPI

enum AppRoute: Hashable {
    case player(Song)
    case album(collectionId: Int)
}
