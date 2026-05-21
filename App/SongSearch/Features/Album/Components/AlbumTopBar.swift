import SwiftUI
import DesignSystem
import Localization

struct AlbumTopBar: View {
    @Environment(\.dsPalette) private var palette

    let onBack: () -> Void

    var body: some View {
        HStack {
            circleButton(systemImage: "chevron.left", action: onBack)
                .accessibilityLabel(L10n.A11y.back)
            Spacer()
            Text(L10n.Album.title)
                .font(.dsLabelUppercase)
                .tracking(0.4)
                .foregroundStyle(palette.textSecondary)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            Color.clear
                .frame(width: 36, height: 36)
                .accessibilityHidden(true)
        }
        .padding(.horizontal, DSSpacing.large)
        .padding(.top, DSSpacing.small)
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
