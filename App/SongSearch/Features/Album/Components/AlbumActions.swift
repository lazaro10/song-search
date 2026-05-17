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
                    Text("Play")
                        .font(.dsBody)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: Color.accentColor.opacity(0.3), radius: 8, y: 4)
            }
            .buttonStyle(.plain)

            Button(action: onShuffle) {
                HStack(spacing: 8) {
                    Image(systemName: "shuffle")
                        .font(.system(size: 14, weight: .bold))
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
        }
        .padding(.horizontal, 20)
    }
}
