import SwiftUI

struct AlbumView: View {
    let viewModel: AlbumViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Album")
                .font(.title)
            Text("collectionId: \(viewModel.collectionId)")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Album")
    }
}
