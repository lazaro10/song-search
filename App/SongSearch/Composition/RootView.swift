import SwiftUI
import DesignSystem
import Storage

struct RootView: View {
    @AppStorage("dsAccent") private var accent: DSAccent = .deepPurple
    @State private var showSplash = true
    @State private var router = AppRouter()
    @State private var recentlyPlayedRepository: any RecentlyPlayedRepository

    init() {
        let container = (try? StorageContainer.make()) ?? (try! StorageContainer.makeInMemory())
        _recentlyPlayedRepository = State(initialValue: SwiftDataRecentlyPlayedRepository(container: container))
    }

    var body: some View {
        @Bindable var router = router

        Group {
            if showSplash {
                SplashView(onComplete: { showSplash = false })
                    .transition(.opacity)
            } else {
                NavigationStack(path: $router.path) {
                    HomeBuilder.build(recentlyPlayedRepository: recentlyPlayedRepository)
                        .navigationDestination(for: AppRoute.self) { route in
                            switch route {
                            case let .player(song):
                                PlayerBuilder.build(
                                    song: song,
                                    recentlyPlayedRepository: recentlyPlayedRepository
                                )
                            case let .album(collectionId):
                                AlbumBuilder.build(collectionId: collectionId)
                            }
                        }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: showSplash)
        .dsAccent(accent)
        .environment(router)
    }
}
