import SwiftUI
import DesignSystem
import Localization

struct PlayerTopBar: View {
    @Environment(\.dsPalette) private var palette

    let onBack: () -> Void
    let onMore: () -> Void

    var body: some View {
        HStack {
            circleButton(systemImage: "chevron.left", action: onBack)
                .accessibilityLabel(L10n.A11y.back)
            Spacer()
            Text(L10n.Player.title)
                .font(.dsLabelUppercase)
                .tracking(0.4)
                .foregroundStyle(palette.textSecondary)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            circleButton(systemImage: "ellipsis", action: onMore)
                .accessibilityLabel(L10n.A11y.moreOptions)
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
