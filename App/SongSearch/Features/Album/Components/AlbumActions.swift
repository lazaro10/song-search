import SwiftUI
import DesignSystem

struct AlbumActions: View {
    @Environment(\.dsPalette) private var palette

    let onPlay: () -> Void
    let onShuffle: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onPlay) {
                HStack(spacing: 8) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 14, weight: .bold))
                        .accessibilityHidden(true)
                    Text("Play")
                        .font(.dsBody)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: Color.accentColor.opacity(0.3), radius: 8, y: 4)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Play")
            .accessibilityHint("Plays the album from the first track")

            Button(action: onShuffle) {
                HStack(spacing: 8) {
                    Image(systemName: "shuffle")
                        .font(.system(size: 14, weight: .bold))
                        .accessibilityHidden(true)
                    Text("Shuffle")
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
            .accessibilityLabel("Shuffle")
            .accessibilityHint("Plays a random track from the album")
        }
        .padding(.horizontal, 20)
    }
}
