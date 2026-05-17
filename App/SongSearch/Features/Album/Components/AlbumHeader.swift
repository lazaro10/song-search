import SwiftUI
import SongAPI
import DesignSystem

struct AlbumHeader: View {
    @Environment(\.dsPalette) private var palette

    let album: Album

    var body: some View {
        VStack(spacing: 4) {
            CoverArtView(url: album.artworkURL, size: 196, cornerRadius: 18)
                .shadow(color: .black.opacity(0.18), radius: 24, y: 14)
                .padding(.bottom, 14)

            Text(album.name)
                .font(.dsScreenTitle)
                .foregroundStyle(palette.text)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            Text(album.artistName)
                .font(.dsItemTitle)
                .foregroundStyle(.tint)

            Text(metaLine)
                .font(.dsCaptionSmall)
                .foregroundStyle(palette.textSecondary)
                .padding(.top, 2)
        }
        .padding(.horizontal, 24)
    }

    private var metaLine: String {
        var parts: [String] = ["Album"]
        if let year = album.releaseYear { parts.append(String(year)) }
        parts.append("\(album.trackCount) track\(album.trackCount == 1 ? "" : "s")")
        return parts.joined(separator: " · ")
    }
}
