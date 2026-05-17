import SwiftUI
import SongAPI

enum AlbumBuilder {
    @MainActor
    static func build(
        collectionId: Int,
        songRepository: any SongRepository
    ) -> some View {
        let viewModel = AlbumViewModel(collectionId: collectionId, songRepository: songRepository)
        return AlbumView(viewModel: viewModel)
    }
}
