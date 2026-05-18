import SwiftUI
import Networking

/// Cached square cover artwork. Reads from `ImageDiskCache` first so it stays
/// useful offline; falls back to a `music.note` placeholder when no image is
/// available.
///
/// Automatically retries the load when `NetworkReachability` flips from offline
/// back to online (via the `retryToken` baked into the task id).
///
/// Pass an `accessibilityLabel` when the image conveys information not already
/// available to assistive tech via adjacent text; otherwise it's marked
/// decorative.
public struct DSCoverArt: View {
    @Environment(\.dsPalette) private var palette
    @Environment(NetworkReachability.self) private var reachability

    private let url: URL?
    private let size: CGFloat
    private let cornerRadius: CGFloat
    private let accessibilityLabel: String?

    @State private var image: Image?

    public init(
        url: URL?,
        size: CGFloat,
        cornerRadius: CGFloat,
        accessibilityLabel: String? = nil
    ) {
        self.url = url
        self.size = size
        self.cornerRadius = cornerRadius
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
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
        image = await DSImageLoader.load(from: url)
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
