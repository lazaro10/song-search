import SwiftUI

struct MoreOptionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("More options")
                .font(.headline)
                .padding()

            Divider()

            List {
                Label("Share", systemImage: "square.and.arrow.up")
                Label("Add to playlist", systemImage: "text.badge.plus")
                Label("View album", systemImage: "square.stack")
            }
            .listStyle(.plain)
        }
    }
}
