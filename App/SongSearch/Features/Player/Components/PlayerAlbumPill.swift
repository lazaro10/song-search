import SwiftUI
import SongAPI
import DesignSystem

struct PlayerAlbumPill: View {
    @Environment(\.dsPalette) private var palette

    let song: Song

    var body: some View {
        if let albumName = song.albumName, let albumId = song.albumId {
            NavigationLink(value: AppRoute.album(collectionId: albumId)) {
                HStack(spacing: DSSpacing.small) {
                    Image(systemName: "opticaldisc")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(palette.textSecondary)
                        .accessibilityHidden(true)
                    Text("From the album · \(albumName)")
                        .font(.dsCaption)
                        .foregroundStyle(palette.text)
                }
                .padding(.horizontal, DSSpacing.large)
                .padding(.vertical, DSSpacing.small)
                .background(
                    Capsule().fill(palette.text.opacity(0.04))
                )
                .overlay(
                    Capsule().stroke(palette.hairline, lineWidth: 0.5)
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("From the album \(albumName)")
            .accessibilityHint("Opens the album")
        }
    }
}
