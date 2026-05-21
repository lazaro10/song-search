import Foundation
import SongAPI

@MainActor
public protocol AlbumCache: Sendable {
    func fetch(collectionId: Int) async -> Album?
    func save(_ album: Album) async
}
