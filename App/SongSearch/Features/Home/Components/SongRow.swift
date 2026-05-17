import SwiftUI
import SongAPI
import DesignSystem

struct SongRow: View {
    @Environment(\.dsPalette) private var palette

    let song: Song
    let showDivider: Bool
    let onMore: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            CoverArtView(url: song.artworkURL, size: 48, cornerRadius: 8)

            VStack(alignment: .leading, spacing: 2) {
                Text(song.name)
                    .font(.dsItemTitle)
                    .foregroundStyle(palette.text)
                    .lineLimit(1)
                Text(song.artistName)
                    .font(.dsCaption)
                    .foregroundStyle(palette.textSecondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 4)

            Text(formatDuration(song.duration))
                .font(.dsCaption)
                .foregroundStyle(palette.textSecondary)
                .monospacedDigit()

            Button(action: onMore) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18))
                    .foregroundStyle(palette.textSecondary)
                    .frame(width: 30, height: 30)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .overlay(alignment: .bottom) {
            if showDivider {
                Rectangle()
                    .fill(palette.hairline)
                    .frame(height: 0.5)
                    .padding(.leading, 72)
            }
        }
    }

    private func formatDuration(_ seconds: TimeInterval) -> String {
        let total = Int(seconds.rounded())
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}
