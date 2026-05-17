import Foundation
import SwiftData
import SongAPI

@MainActor
public final class SwiftDataAlbumCache: AlbumCache {
    private let context: ModelContext

    public init(container: ModelContainer) {
        self.context = ModelContext(container)
    }

    public func fetch(collectionId: Int) async -> Album? {
        var descriptor = FetchDescriptor<CachedAlbum>(
            predicate: #Predicate<CachedAlbum> { $0.id == collectionId }
        )
        descriptor.fetchLimit = 1
        return (try? context.fetch(descriptor).first)?.toAlbum()
    }

    public func save(_ album: Album) async {
        let id = album.id
        var descriptor = FetchDescriptor<CachedAlbum>(
            predicate: #Predicate<CachedAlbum> { $0.id == id }
        )
        descriptor.fetchLimit = 1

        if let existing = try? context.fetch(descriptor).first {
            existing.update(from: album)
        } else {
            context.insert(CachedAlbum(from: album))
        }

        try? context.save()
    }
}
