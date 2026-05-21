import Foundation
import SwiftData

public enum StorageContainer {
    @MainActor
    public static func make() throws -> ModelContainer {
        try ModelContainer(for: CachedSong.self, CachedAlbum.self)
    }

    @MainActor
    public static func makeInMemory() throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: CachedSong.self, CachedAlbum.self, configurations: configuration)
    }
}
