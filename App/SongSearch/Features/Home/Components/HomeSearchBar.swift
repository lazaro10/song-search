import SwiftUI
import DesignSystem
import Localization

struct HomeSearchBar: View {
    @Environment(\.dsPalette) private var palette
    @Binding var text: String
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: DSSpacing.small) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 17))
                .foregroundStyle(palette.textSecondary)

            TextField(L10n.Home.searchPlaceholder, text: $text)
                .focused($isFocused)
                .font(.system(size: 16))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .tint(.accentColor)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(palette.background)
                        .frame(width: 18, height: 18)
                        .background(Circle().fill(palette.textTertiary))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(L10n.A11y.clearSearch)
            }
        }
        .padding(.horizontal, DSSpacing.medium)
        .frame(height: 38)
        .background(palette.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(isFocused ? Color.accentColor : .clear, lineWidth: 1.5)
        }
        .animation(.easeOut(duration: 0.15), value: isFocused)
    }
}
