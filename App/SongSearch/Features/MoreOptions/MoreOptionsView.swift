import SwiftUI
import SongAPI
import DesignSystem

struct MoreOptionsView: View {
    @Environment(\.dsPalette) private var palette
    @Environment(\.dismiss) private var dismiss

    let viewModel: MoreOptionsViewModel
    let onSelectAlbum: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            songHeader

            VStack(spacing: 0) {
                if viewModel.canViewAlbum, let albumId = viewModel.song.albumId {
                    Button {
                        dismiss()
                        onSelectAlbum(albumId)
                    } label: {
                        actionRow(
                            icon: "square.stack",
                            label: "View Album",
                            sub: viewModel.song.albumName ?? "Open album",
                            showDivider: true
                        )
                    }
                    .buttonStyle(.plain)
                }

                ShareLink(item: viewModel.shareMessage) {
                    actionRow(
                        icon: "square.and.arrow.up",
                        label: "Share",
                        sub: "Send to a friend",
                        showDivider: false
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 8)

            Spacer()
        }
    }

    private var songHeader: some View {
        HStack(spacing: 12) {
            CoverArtView(url: viewModel.song.artworkURL, size: 48, cornerRadius: 8)

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.song.name)
                    .font(.dsBody)
                    .foregroundStyle(palette.text)
                    .lineLimit(1)
                Text(viewModel.song.artistName)
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
    }

    private func actionRow(icon: String, label: String, sub: String, showDivider: Bool) -> some View {
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
