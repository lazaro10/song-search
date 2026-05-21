import SwiftUI
import SongAPI
import DesignSystem
import Localization

struct RecentlyPlayedCard: View {
    @Environment(\.dsPalette) private var palette

    let song: Song

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.small) {
            DSCoverArt(url: song.artworkURL, size: 96, cornerRadius: 12)
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
        .accessibilityLabel(L10n.A11y.songCardLabel(name: song.name, artist: song.artistName))
        .accessibilityHint(L10n.A11y.opensPlayer)
    }
}
