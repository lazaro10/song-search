import SwiftUI
import DesignSystem

struct RootView: View {
    @AppStorage("dsAccent") private var accent: DSAccent = .deepPurple
    @State private var showSplash = true
    @State private var router = AppRouter()

    var body: some View {
        @Bindable var router = router

        Group {
            if showSplash {
                SplashView(onComplete: { showSplash = false })
                    .transition(.opacity)
            } else {
                NavigationStack(path: $router.path) {
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
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: showSplash)
        .dsAccent(accent)
        .environment(router)
    }
}
