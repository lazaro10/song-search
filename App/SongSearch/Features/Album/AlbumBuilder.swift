import SwiftUI
import SongAPI

enum AlbumBuilder {
    @MainActor
    static func build(
        collectionId: Int,
        albumLookupRepository: any AlbumLookupRepository
    ) -> some View {
        let viewModel = AlbumViewModel(collectionId: collectionId, albumLookupRepository: albumLookupRepository)
        return AlbumView(viewModel: viewModel)
    }
}
