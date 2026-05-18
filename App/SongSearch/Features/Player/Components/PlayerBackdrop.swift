import SwiftUI
import DesignSystem

struct PlayerBackdrop: View {
    @Environment(\.dsPalette) private var palette
    @Environment(\.colorScheme) private var colorScheme

    let artworkURL: URL?

    var body: some View {
        ZStack {
            DSBlurredBackdrop(
                url: artworkURL,
                blurRadius: 60,
                saturation: 1.6,
                opacity: 1.0
            )

            LinearGradient(
                colors: colorScheme == .dark
                    ? [Color.black.opacity(0.35), Color.black.opacity(0.85)]
                    : [Color.white.opacity(0.55), Color.white.opacity(0.92)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}
