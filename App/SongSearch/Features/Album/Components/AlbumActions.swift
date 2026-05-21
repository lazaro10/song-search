import SwiftUI
import DesignSystem
import Localization

struct AlbumActions: View {
    @Environment(\.dsPalette) private var palette

    let onPlay: () -> Void
    let onShuffle: () -> Void

    var body: some View {
        HStack(spacing: DSSpacing.small) {
            Button(action: onPlay) {
                HStack(spacing: DSSpacing.small) {
                    Image(.play)
                        .font(.system(size: 14, weight: .bold))
                        .accessibilityHidden(true)
                    Text(L10n.Album.play)
                        .font(.dsBody)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: Color.accentColor.opacity(0.3), radius: 8, y: 4)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(L10n.Album.play)
            .accessibilityHint(L10n.Album.playHint)

            Button(action: onShuffle) {
                HStack(spacing: DSSpacing.small) {
                    Image(.shuffle)
                        .font(.system(size: 14, weight: .bold))
                        .accessibilityHidden(true)
                    Text(L10n.Album.shuffle)
                        .font(.dsBody)
                }
                .foregroundStyle(palette.text)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(Color.clear, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(palette.hairline, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel(L10n.Album.shuffle)
            .accessibilityHint(L10n.Album.shuffleHint)
        }
        .padding(.horizontal, DSSpacing.spacious)
    }
}
