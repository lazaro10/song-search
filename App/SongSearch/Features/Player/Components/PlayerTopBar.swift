import SwiftUI
import DesignSystem

struct PlayerTopBar: View {
    @Environment(\.dsPalette) private var palette

    let onBack: () -> Void
    let onMore: () -> Void

    var body: some View {
        HStack {
            circleButton(systemImage: "chevron.left", action: onBack)
            Spacer()
            Text("NOW PLAYING")
                .font(.dsLabelUppercase)
                .tracking(0.4)
                .foregroundStyle(palette.textSecondary)
            Spacer()
            circleButton(systemImage: "ellipsis", action: onMore)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private func circleButton(systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(palette.text)
                .frame(width: 36, height: 36)
                .background(Circle().fill(palette.text.opacity(0.06)))
        }
        .buttonStyle(.plain)
    }
}
