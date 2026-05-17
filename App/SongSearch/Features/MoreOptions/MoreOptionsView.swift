import SwiftUI
import SongAPI
import DesignSystem

struct MoreOptionsView: View {
    @Environment(\.dsPalette) private var palette
    @Environment(\.dismiss) private var dismiss

    let song: Song

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                CoverArtView(url: song.artworkURL, size: 48, cornerRadius: 8)

                VStack(alignment: .leading, spacing: 2) {
                    Text(song.name)
                        .font(.dsBody)
                        .foregroundStyle(palette.text)
                        .lineLimit(1)
                    Text(song.artistName)
                        .font(.dsCaption)
                        .foregroundStyle(palette.textSecondary)
                        .lineLimit(1)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 16)
            .overlay(alignment: .bottom) {
                Rectangle().fill(palette.hairline).frame(height: 0.5)
            }

            VStack(spacing: 0) {
                row(icon: "square.stack", label: "View Album", sub: song.albumName ?? "Open album")
                row(icon: "clock.badge.plus", label: "Add to Recently Played", sub: "Save for later", showDivider: true)
                row(icon: "square.and.arrow.up", label: "Share", sub: "Send to a friend", showDivider: false)
            }
            .padding(.top, 8)

            Spacer()
        }
    }

    @ViewBuilder
    private func row(icon: String, label: String, sub: String, showDivider: Bool = true) -> some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.accentColor.opacity(0.15))
                        .frame(width: 38, height: 38)
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.tint)
                }

                VStack(alignment: .leading, spacing: 1) {
                    Text(label)
                        .font(.dsItemTitle)
                        .foregroundStyle(palette.text)
                    Text(sub)
                        .font(.dsCaptionSmall)
                        .foregroundStyle(palette.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(palette.textTertiary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .overlay(alignment: .bottom) {
            if showDivider {
                Rectangle()
                    .fill(palette.hairline)
                    .frame(height: 0.5)
                    .padding(.leading, 74)
            }
        }
    }
}
