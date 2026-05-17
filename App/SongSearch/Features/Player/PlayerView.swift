import SwiftUI

struct PlayerView: View {
    let viewModel: PlayerViewModel
    @State private var showingMoreOptions = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Player")
                .font(.title)
            Text(viewModel.song.name)
                .font(.headline)
            Text(viewModel.song.artistName)
                .foregroundStyle(.secondary)
            Button("More options") { showingMoreOptions = true }
                .padding(.top)
        }
        .padding()
        .navigationTitle("Now Playing")
        .sheet(isPresented: $showingMoreOptions) {
            MoreOptionsView()
                .presentationDetents([.medium])
        }
    }
}
