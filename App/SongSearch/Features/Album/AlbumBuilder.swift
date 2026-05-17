import SwiftUI
import SongAPI

enum AlbumBuilder {
    @MainActor
    static func build(collectionId: Int) -> some View {
        let songRepository = SongRepositoryImplementation()
        let viewModel = AlbumViewModel(collectionId: collectionId, songRepository: songRepository)
        return AlbumView(viewModel: viewModel)
    }
}
