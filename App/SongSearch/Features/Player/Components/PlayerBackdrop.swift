import SwiftUI
import DesignSystem

struct PlayerBackdrop: View {
    @Environment(\.dsPalette) private var palette
    @Environment(\.colorScheme) private var colorScheme

    let artworkURL: URL?

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if let artworkURL {
                    AsyncImage(url: artworkURL) { phase in
                        if case let .success(image) = phase {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: proxy.size.width, height: proxy.size.height)
                                .clipped()
                                .blur(radius: 60)
                                .saturation(1.6)
                        } else {
                            palette.background
                        }
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
                } else {
                    palette.background
                }

                LinearGradient(
                    colors: colorScheme == .dark
                        ? [Color.black.opacity(0.35), Color.black.opacity(0.85)]
                        : [Color.white.opacity(0.55), Color.white.opacity(0.92)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}
