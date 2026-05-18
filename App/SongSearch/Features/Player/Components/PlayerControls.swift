import SwiftUI
import DesignSystem

struct PlayerControls: View {
    @Environment(\.dsPalette) private var palette

    let isPlaying: Bool
    let onPlayPause: () -> Void
    let onSkipBack: () -> Void
    let onSkipForward: () -> Void

    var body: some View {
        HStack(spacing: 36) {
            secondaryButton(systemImage: "backward.fill", size: 26, action: onSkipBack)
                .accessibilityLabel("Skip backward")

            Button(action: onPlayPause) {
                ZStack {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 76, height: 76)
                        .shadow(color: Color.accentColor.opacity(0.4), radius: 14, y: 10)
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                        .offset(x: isPlaying ? 0 : 2)
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isPlaying ? "Pause" : "Play")

            secondaryButton(systemImage: "forward.fill", size: 26, action: onSkipForward)
                .accessibilityLabel("Skip forward")
        }
        .padding(.top, 34)
    }

    private func secondaryButton(systemImage: String, size: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: size, weight: .semibold))
                .foregroundStyle(palette.text)
                .frame(width: 56, height: 56)
                .background(Circle().fill(palette.text.opacity(0.06)))
        }
        .buttonStyle(.plain)
    }
}
