import SwiftUI
import DesignSystem
import Localization

struct PlayerControls: View {
    @Environment(\.dsPalette) private var palette

    let isPlaying: Bool
    let onPlayPause: () -> Void
    let onSkipBack: () -> Void
    let onSkipForward: () -> Void

    var body: some View {
        HStack(spacing: DSSpacing.huge) {
            secondaryButton(icon: .skipBackward, size: 26, action: onSkipBack)
                .accessibilityLabel(L10n.A11y.skipBackward)

            Button(action: onPlayPause) {
                ZStack {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 76, height: 76)
                        .shadow(color: Color.accentColor.opacity(0.4), radius: 14, y: 10)
                    Image(isPlaying ? .pause : .play)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                        .offset(x: isPlaying ? 0 : 2)
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isPlaying ? L10n.A11y.pause : L10n.A11y.play)

            secondaryButton(icon: .skipForward, size: 26, action: onSkipForward)
                .accessibilityLabel(L10n.A11y.skipForward)
        }
        .padding(.top, DSSpacing.huge)
    }

    private func secondaryButton(icon: DSIcon, size: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(icon)
                .font(.system(size: size, weight: .semibold))
                .foregroundStyle(palette.text)
                .frame(width: 56, height: 56)
                .background(Circle().fill(palette.text.opacity(0.06)))
        }
        .buttonStyle(.plain)
    }
}
