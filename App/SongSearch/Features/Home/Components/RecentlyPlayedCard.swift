import SwiftUI
import SongAPI
import DesignSystem

struct RecentlyPlayedCard: View {
    @Environment(\.dsPalette) private var palette

    let song: Song

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CoverArtView(url: song.artworkURL, size: 96, cornerRadius: 12)
            Text(song.name)
                .font(.dsCaption)
                .foregroundStyle(palette.text)
                .lineLimit(1)
            Text(song.artistName)
                .font(.dsCaptionTiny)
                .foregroundStyle(palette.textSecondary)
                .lineLimit(1)
        }
        .frame(width: 96, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(song.name), \(song.artistName)")
        .accessibilityHint("Opens the player")
    }
}
