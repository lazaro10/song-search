import SwiftUI

struct SplashView: View {
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "music.note")
                .font(.system(size: 64))
                .foregroundStyle(.tint)
            Text("Song Search")
                .font(.largeTitle)
                .bold()
            ProgressView()
                .padding(.top, 8)
        }
        .task {
            try? await Task.sleep(for: .seconds(1.5))
            onComplete()
        }
    }
}
