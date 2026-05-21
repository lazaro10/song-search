import Foundation

public protocol AlbumLookupRepository: Sendable {
    func album(collectionId: Int) async throws -> Album
}

public enum AlbumLookupError: Error, Equatable, Sendable {
    case albumNotFound
}
