import SwiftUI
import DesignSystem

struct AlbumBackdrop: View {
    @Environment(\.dsPalette) private var palette
    @Environment(\.colorScheme) private var colorScheme

    let artworkURL: URL?

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                palette.background

                if let artworkURL {
                    AsyncImage(url: artworkURL) { phase in
                        if case let .success(image) = phase {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: proxy.size.width, height: 360)
                                .clipped()
                                .blur(radius: 20)
                                .saturation(1.2)
                                .opacity(colorScheme == .dark ? 0.35 : 0.30)
                        }
                    }
                    .frame(width: proxy.size.width, height: 360)
                    .clipped()
                }

                LinearGradient(
                    colors: [palette.background.opacity(0), palette.background],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: proxy.size.width, height: 380)
            }
        }
        .ignoresSafeArea()
    }
}
