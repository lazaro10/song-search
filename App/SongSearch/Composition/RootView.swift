import SwiftUI
import SongAPI
import Networking
import DesignSystem
import Storage

struct RootView: View {
    @AppStorage("dsAccent") private var accent: DSAccent = .deepPurple
    @State private var showSplash = true
    @State private var router = AppRouter()
    @State private var reachability = NetworkReachability()
    @State private var songRepository: any SongRepository
    @State private var recentlyPlayedRepository: any RecentlyPlayedRepository

    init() {
        let container = (try? StorageContainer.make()) ?? (try! StorageContainer.makeInMemory())
        let albumCache = SwiftDataAlbumCache(container: container)
        let networkRepo = SongRepositoryImplementation()
        let cachingRepo = CachingSongRepository(wrapped: networkRepo, albumCache: albumCache)
        _songRepository = State(initialValue: cachingRepo)
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
                    HomeBuilder.build(
                        songRepository: songRepository,
                        recentlyPlayedRepository: recentlyPlayedRepository
                    )
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case let .player(song):
                            PlayerBuilder.build(
                                song: song,
                                recentlyPlayedRepository: recentlyPlayedRepository
                            )
                        case let .album(collectionId):
                            AlbumBuilder.build(
                                collectionId: collectionId,
                                songRepository: songRepository
                            )
                        }
                    }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: showSplash)
        .overlay(alignment: .top) {
            OfflineBanner()
        }
        .dsAccent(accent)
        .environment(router)
        .environment(reachability)
    }
}

private struct OfflineBanner: View {
    @Environment(\.dsPalette) private var palette
    @Environment(NetworkReachability.self) private var reachability

    var body: some View {
        if !reachability.isOnline {
            HStack(spacing: 8) {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 13, weight: .semibold))
                    .accessibilityHidden(true)
                Text("You\u{2019}re offline · Showing cached results")
                    .font(.dsCaptionSmall)
            }
            .foregroundStyle(palette.text)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.thinMaterial, in: Capsule())
            .padding(.top, 4)
            .transition(.move(edge: .top).combined(with: .opacity))
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Offline. Showing cached results.")
        }
    }
}
