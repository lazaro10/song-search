import SwiftUI
import CoreGraphics
import ImageIO
import Networking
import DesignSystem

struct CoverArtView: View {
    @Environment(\.dsPalette) private var palette
    @Environment(NetworkReachability.self) private var reachability

    let url: URL?
    let size: CGFloat
    let cornerRadius: CGFloat
    let accessibilityLabel: String?

    @State private var image: Image?

    init(url: URL?, size: CGFloat, cornerRadius: CGFloat, accessibilityLabel: String? = nil) {
        self.url = url
        self.size = size
        self.cornerRadius = cornerRadius
        self.accessibilityLabel = accessibilityLabel
    }

    var body: some View {
        Group {
            if let image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                placeholder
            }
        }
        .frame(width: size, height: size)
        .background(palette.surface)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .task(id: taskID) {
            await loadImage()
        }
        .modifier(AccessibilityModifier(label: accessibilityLabel))
    }

    private var taskID: String {
        "\(url?.absoluteString ?? "")-\(reachability.retryToken)"
    }

    private func loadImage() async {
        guard let url else {
            image = nil
            return
        }

        if let data = ImageDiskCache.shared.data(for: url),
           let cached = Self.makeImage(from: data) {
            image = cached
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            ImageDiskCache.shared.save(data, for: url)
            if let fetched = Self.makeImage(from: data) {
                image = fetched
            }
        } catch {
            // Network failure — keep showing the placeholder.
        }
    }

    private static func makeImage(from data: Data) -> Image? {
        guard
            let source = CGImageSourceCreateWithData(data as CFData, nil),
            let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil)
        else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }

    private var placeholder: some View {
        Image(systemName: "music.note")
            .font(.system(size: size * 0.4, weight: .medium))
            .foregroundStyle(palette.textSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Applies an accessibility label when provided, otherwise hides the cover
/// from assistive tech (so adjacent text isn't read twice).
private struct AccessibilityModifier: ViewModifier {
    let label: String?

    func body(content: Content) -> some View {
        if let label {
            content
                .accessibilityElement()
                .accessibilityLabel(label)
                .accessibilityAddTraits(.isImage)
        } else {
            content.accessibilityHidden(true)
        }
    }
}
