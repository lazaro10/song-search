import SwiftUI
import DesignSystem

struct PlayerProgress: View {
    @Environment(\.dsPalette) private var palette

    let currentTime: TimeInterval
    let duration: TimeInterval

    private var progress: Double {
        guard duration > 0 else { return 0 }
        return max(0, min(1, currentTime / duration))
    }

    var body: some View {
        VStack(spacing: 8) {
            progressBar
            timestamps
        }
        .padding(.horizontal, 28)
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
            Text(format(currentTime))
            Spacer()
            Text("-\(format(max(0, duration - currentTime)))")
        }
        .font(.dsCaptionSmall)
        .foregroundStyle(palette.textSecondary)
        .monospacedDigit()
    }

    private func format(_ seconds: TimeInterval) -> String {
        let total = Int(seconds.rounded())
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}
