import SwiftUI

struct RootView: View {
    @State private var showSplash = true
    @State private var navigationPath = NavigationPath()

    var body: some View {
        Group {
            if showSplash {
                SplashView(onComplete: { showSplash = false })
            } else {
                NavigationStack(path: $navigationPath) {
                    HomeBuilder.build()
                        .navigationDestination(for: AppRoute.self) { route in
                            switch route {
                            case let .player(song):
                                PlayerBuilder.build(song: song)
                            case let .album(collectionId):
                                AlbumBuilder.build(collectionId: collectionId)
                            }
                        }
                }
            }
        }
    }
}
