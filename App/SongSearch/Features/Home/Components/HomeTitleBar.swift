import SwiftUI
import DesignSystem
import Localization

struct HomeTitleBar: View {
    @Environment(\.dsPalette) private var palette

    var body: some View {
        HStack(alignment: .bottom) {
            Text(L10n.Home.title)
                .font(.dsLargeTitle)
                .foregroundStyle(palette.text)
            Spacer()
        }
    }
}
