import Foundation
import CryptoKit

public final class ImageDiskCache: Sendable {
    public static let shared = ImageDiskCache()

    private let directory: URL

    public init(directory: URL? = nil) {
        let resolved = directory ?? Self.defaultDirectory()
        self.directory = resolved
        try? FileManager.default.createDirectory(at: resolved, withIntermediateDirectories: true)
    }

    public func data(for url: URL) -> Data? {
        try? Data(contentsOf: fileURL(for: url))
    }

    public func save(_ data: Data, for url: URL) {
        try? data.write(to: fileURL(for: url), options: .atomic)
    }

    private func fileURL(for url: URL) -> URL {
        directory.appendingPathComponent(Self.key(for: url))
    }

    static func key(for url: URL) -> String {
        SHA256.hash(data: Data(url.absoluteString.utf8))
            .map { String(format: "%02x", $0) }
            .joined()
    }

    private static func defaultDirectory() -> URL {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return caches.appendingPathComponent("song-search.images", isDirectory: true)
    }
}
