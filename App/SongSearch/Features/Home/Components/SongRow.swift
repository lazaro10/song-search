import SwiftUI
import SongAPI
import DesignSystem

struct SongRow: View {
    @Environment(\.dsPalette) private var palette

    let song: Song
    let showDivider: Bool
    let onMore: () -> Void

    var body: some View {
        HStack(spacing: DSSpacing.medium) {
            DSCoverArt(url: song.artworkURL, size: 48, cornerRadius: 8)

            VStack(alignment: .leading, spacing: DSSpacing.micro) {
                Text(song.name)
                    .font(.dsItemTitle)
                    .foregroundStyle(palette.text)
                    .lineLimit(1)
                Text(song.artistName)
                    .font(.dsCaption)
                    .foregroundStyle(palette.textSecondary)
                    .lineLimit(1)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(song.name), \(song.artistName), \(formatDuration(song.duration))")

            Spacer(minLength: DSSpacing.tiny)

            Text(formatDuration(song.duration))
                .font(.dsCaption)
                .foregroundStyle(palette.textSecondary)
                .monospacedDigit()
                .accessibilityHidden(true)

            Button(action: onMore) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18))
                    .foregroundStyle(palette.textSecondary)
                    .frame(width: 30, height: 30)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("More options for \(song.name)")
        }
        .padding(.horizontal, DSSpacing.medium)
        .padding(.vertical, DSSpacing.small)
        .contentShape(Rectangle())
        .overlay(alignment: .bottom) {
            if showDivider {
                Rectangle()
                    .fill(palette.hairline)
                    .frame(height: 0.5)
                    .padding(.leading, 72)
                    .accessibilityHidden(true)
            }
        }
    }

    private func formatDuration(_ seconds: TimeInterval) -> String {
        let total = Int(seconds.rounded())
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}
