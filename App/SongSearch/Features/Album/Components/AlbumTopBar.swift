import SwiftUI
import DesignSystem

struct AlbumTopBar: View {
    @Environment(\.dsPalette) private var palette

    let onBack: () -> Void

    var body: some View {
        HStack {
            circleButton(systemImage: "chevron.left", action: onBack)
                .accessibilityLabel("Back")
            Spacer()
            Text("ALBUM")
                .font(.dsLabelUppercase)
                .tracking(0.4)
                .foregroundStyle(palette.textSecondary)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            Color.clear
                .frame(width: 36, height: 36)
                .accessibilityHidden(true)
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
