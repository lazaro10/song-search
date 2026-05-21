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
            .padding(.top, DSSpacing.small)

            Spacer()
        }
    }

    private var songHeader: some View {
        HStack(spacing: DSSpacing.medium) {
            DSCoverArt(url: viewModel.song.artworkURL, size: 48, cornerRadius: 8)

            VStack(alignment: .leading, spacing: DSSpacing.micro) {
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
        .padding(.horizontal, DSSpacing.spacious)
        .padding(.top, DSSpacing.large)
        .padding(.bottom, DSSpacing.large)
        .overlay(alignment: .bottom) {
            Rectangle().fill(palette.hairline).frame(height: 0.5)
        }
    }

    private func actionRow(icon: String, label: String, sub: String, showDivider: Bool) -> some View {
        HStack(spacing: DSSpacing.large) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.accentColor.opacity(0.15))
                    .frame(width: 38, height: 38)
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.tint)
            }
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: DSSpacing.micro) {
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
                .accessibilityHidden(true)
        }
        .padding(.horizontal, DSSpacing.spacious)
        .padding(.vertical, DSSpacing.medium)
        .contentShape(Rectangle())
        .overlay(alignment: .bottom) {
            if showDivider {
                Rectangle()
                    .fill(palette.hairline)
                    .frame(height: 0.5)
                    // 74 = icon container (38) + HStack gap (16) + horizontal padding (20)
                    .padding(.leading, 74)
                    .accessibilityHidden(true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label). \(sub)")
    }
}
