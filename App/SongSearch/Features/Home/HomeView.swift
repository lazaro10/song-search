import SwiftUI
import SongAPI

struct HomeView: View {
    @Bindable var viewModel: HomeViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Home (Songs)")
                .font(.title)

            NavigationLink("Open Player", value: AppRoute.player(.placeholder))
            NavigationLink("Open Album", value: AppRoute.album(collectionId: 0))
        }
        .padding()
        .navigationTitle("Songs")
    }
}

private extension Song {
    static let placeholder = Song(
        id: 0,
        name: "Placeholder",
        artistName: "Artist",
        albumName: "Album",
        albumId: 0,
        artworkURL: nil,
        previewURL: nil,
        duration: 0
    )
}
