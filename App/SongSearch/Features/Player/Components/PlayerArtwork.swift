import SwiftUI
import DesignSystem

struct PlayerArtwork: View {
    let artworkURL: URL?
    let isPlaying: Bool

    var body: some View {
        DSCoverArt(url: artworkURL, size: 280, cornerRadius: 24)
            .shadow(color: .black.opacity(0.18), radius: 30, y: 18)
            .scaleEffect(isPlaying ? 1.0 : 0.92)
            .animation(.spring(response: 0.45, dampingFraction: 0.75), value: isPlaying)
            .padding(.vertical, 24)
            .accessibilityHidden(true)
    }
}
