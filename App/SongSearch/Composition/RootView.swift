import SwiftUI
import SongAPI
import Networking
import DesignSystem
import Localization
import Storage

struct RootView: View {
    @AppStorage("dsAccent") private var accent: DSAccent = .deepPurple
    @State private var showSplash = true
    @State private var router = AppRouter()
    @State private var reachability = NetworkReachability()
    @State private var songSearchRepository: any SongSearchRepository
    @State private var albumLookupRepository: any AlbumLookupRepository
    @State private var recentlyPlayedRepository: any RecentlyPlayedRepository
    @State private var searchHistoryRepository: any SearchHistoryRepository

    init() {
        let container = (try? StorageContainer.make()) ?? (try! StorageContainer.makeInMemory())
        let albumCache = SwiftDataAlbumCache(container: container)
        let networkAlbumLookup = AlbumLookupRepositoryImplementation()
        let cachingAlbumLookup = CachingAlbumLookupRepository(wrapped: networkAlbumLookup, albumCache: albumCache)
        _songSearchRepository = State(initialValue: SongSearchRepositoryImplementation())
        _albumLookupRepository = State(initialValue: cachingAlbumLookup)
        _recentlyPlayedRepository = State(initialValue: SwiftDataRecentlyPlayedRepository(container: container))
        _searchHistoryRepository = State(initialValue: UserDefaultsSearchHistoryRepository())
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
                        songSearchRepository: songSearchRepository,
                        recentlyPlayedRepository: recentlyPlayedRepository,
                        searchHistoryRepository: searchHistoryRepository
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
                                albumLookupRepository: albumLookupRepository
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
            HStack(spacing: DSSpacing.small) {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 13, weight: .semibold))
                    .accessibilityHidden(true)
                Text(L10n.Offline.banner)
                    .font(.dsCaptionSmall)
            }
            .foregroundStyle(palette.text)
            .padding(.horizontal, DSSpacing.medium)
            .padding(.vertical, DSSpacing.small)
            .background(.thinMaterial, in: Capsule())
            .padding(.top, DSSpacing.tiny)
            .transition(.move(edge: .top).combined(with: .opacity))
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.A11y.offlineBanner)
        }
    }
}
