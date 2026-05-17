import Foundation
import SwiftData
import SongAPI

@MainActor
public final class SwiftDataRecentlyPlayedRepository: RecentlyPlayedRepository {
    private let context: ModelContext
    private let maxItems: Int

    public init(container: ModelContainer, maxItems: Int = 20) {
        self.context = ModelContext(container)
        self.maxItems = maxItems
    }

    public func recentSongs(limit: Int) async -> [Song] {
        var descriptor = FetchDescriptor<CachedSong>(
            sortBy: [SortDescriptor(\.playedAt, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        let cached = (try? context.fetch(descriptor)) ?? []
        return cached.map { $0.asSong }
    }

    public func add(_ song: Song) async {
        let id = song.id
        var existingDescriptor = FetchDescriptor<CachedSong>(
            predicate: #Predicate<CachedSong> { $0.id == id }
        )
        existingDescriptor.fetchLimit = 1

        if let existing = try? context.fetch(existingDescriptor).first {
            existing.playedAt = .now
        } else {
            context.insert(CachedSong(from: song))
            enforceCap()
        }

        try? context.save()
    }

    private func enforceCap() {
        let descriptor = FetchDescriptor<CachedSong>(
            sortBy: [SortDescriptor(\.playedAt, order: .reverse)]
        )
        guard let all = try? context.fetch(descriptor), all.count > maxItems else { return }
        for song in all[maxItems...] {
            context.delete(song)
        }
    }
}
