import SwiftUI
import DesignSystem

struct RootView: View {
    @AppStorage("dsAccent") private var accent: DSAccent = .deepPurple
    @State private var showSplash = true
    @State private var navigationPath = NavigationPath()

    var body: some View {
        Group {
            if showSplash {
                SplashView(onComplete: { showSplash = false })
                    .transition(.opacity)
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
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: showSplash)
        .dsAccent(accent)
    }
}
