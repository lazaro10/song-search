import SwiftUI
import DesignSystem

struct AlbumBackdrop: View {
    @Environment(\.dsPalette) private var palette
    @Environment(\.colorScheme) private var colorScheme

    let artworkURL: URL?

    var body: some View {
        ZStack(alignment: .top) {
            DSBlurredBackdrop(
                url: artworkURL,
                blurRadius: 20,
                saturation: 1.2,
                opacity: colorScheme == .dark ? 0.35 : 0.30,
                height: 360
            )
            .frame(height: 360)

            LinearGradient(
                colors: [palette.background.opacity(0), palette.background],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 380)
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}
