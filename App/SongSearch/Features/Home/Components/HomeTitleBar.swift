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
            ZStack {
                Circle().fill(palette.surface).frame(width: 36, height: 36)
                Image(systemName: "music.note")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.tint)
            }
        }
    }
}
