import SwiftUI
import SongAPI
import DesignSystem

struct AlbumTrackRow: View {
    @Environment(\.dsPalette) private var palette

    let number: Int
    let song: Song
    let showDivider: Bool

    var body: some View {
        HStack(spacing: 16) {
            Text("\(number)")
                .font(.dsCaption)
                .foregroundStyle(palette.textSecondary)
                .monospacedDigit()
                .frame(width: 22, alignment: .trailing)

            Text(song.name)
                .font(.dsItemTitle)
                .foregroundStyle(palette.text)
                .lineLimit(1)

            Spacer(minLength: 8)

            Text(formatDuration(song.duration))
                .font(.dsCaption)
                .foregroundStyle(palette.textSecondary)
                .monospacedDigit()
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .overlay(alignment: .bottom) {
            if showDivider {
                Rectangle()
                    .fill(palette.hairline)
                    .frame(height: 0.5)
                    .accessibilityHidden(true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Track \(number), \(song.name), \(formatDuration(song.duration))")
    }

    private func formatDuration(_ seconds: TimeInterval) -> String {
        let total = Int(seconds.rounded())
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}
