import SwiftUI
import DesignSystem

struct HomeTitleBar: View {
    @Environment(\.dsPalette) private var palette

    var body: some View {
        HStack(alignment: .bottom) {
            Text("Songs")
                .font(.dsLargeTitle)
                .foregroundStyle(palette.text)
            Spacer()
        }
    }
}
