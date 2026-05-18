import SwiftUI
import CoreGraphics
import ImageIO
import Networking

/// Shared image pipeline used by `DSCoverArt` and `DSBlurredBackdrop`.
///
/// Reads from `ImageDiskCache.shared` first; on miss, fetches via
/// `URLSession.shared`, persists the bytes to disk, and decodes through
/// `CGImageSource` so the rendered `Image` is built without going through
/// UIKit.
public enum DSImageLoader {
    public static func load(from url: URL) async -> Image? {
        if let data = ImageDiskCache.shared.data(for: url),
           let cached = makeImage(from: data) {
            return cached
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            ImageDiskCache.shared.save(data, for: url)
            return makeImage(from: data)
        } catch {
            return nil
        }
    }

    private static func makeImage(from data: Data) -> Image? {
        guard
            let source = CGImageSourceCreateWithData(data as CFData, nil),
            let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil)
        else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}
