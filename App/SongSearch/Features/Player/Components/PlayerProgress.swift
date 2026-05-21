import SwiftUI
import DesignSystem
import Formatting
import Localization

struct PlayerProgress: View {
    @Environment(\.dsPalette) private var palette

    let currentTime: TimeInterval
    let duration: TimeInterval

    private var progress: Double {
        guard duration > 0 else { return 0 }
        return max(0, min(1, currentTime / duration))
    }

    var body: some View {
        VStack(spacing: DSSpacing.small) {
            progressBar
            timestamps
        }
        .padding(.horizontal, DSSpacing.big)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.A11y.playbackProgress)
        .accessibilityValue(L10n.A11y.playbackValue(
            current: currentTime.formattedAsMinutesAndSeconds,
            total: duration.formattedAsMinutesAndSeconds
        ))
    }

    private var progressBar: some View {
        Capsule()
            .fill(palette.text.opacity(0.10))
            .frame(height: 4)
            .overlay(alignment: .leading) {
                GeometryReader { geometry in
                    Capsule()
                        .fill(palette.text)
                        .frame(
                            width: max(0, min(geometry.size.width, geometry.size.width * progress)),
                            height: 4
                        )
                }
            }
            .overlay(alignment: .leading) {
                GeometryReader { geometry in
                    let knobX = max(6, min(geometry.size.width - 6, geometry.size.width * progress))
                    Circle()
                        .fill(palette.text)
                        .frame(width: 12, height: 12)
                        .offset(x: knobX - 6, y: -4)
                        .shadow(color: .black.opacity(0.15), radius: 1, y: 1)
                }
            }
    }

    private var timestamps: some View {
        HStack {
            Text(currentTime.formattedAsMinutesAndSeconds)
            Spacer()
            Text("-\(max(0, duration - currentTime).formattedAsMinutesAndSeconds)")
        }
        .font(.dsCaptionSmall)
        .foregroundStyle(palette.textSecondary)
        .monospacedDigit()
    }
}
