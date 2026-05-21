import SwiftUI
import SongAPI
import DesignSystem
import Localization

struct RecentlyPlayedRail: View {
    let songs: [Song]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DSSectionHeader(title: L10n.Home.recentlyPlayed)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DSSpacing.medium) {
                    ForEach(songs) { song in
                        NavigationLink(value: AppRoute.player(song)) {
                            RecentlyPlayedCard(song: song)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, DSSpacing.spacious)
                .padding(.bottom, DSSpacing.spacious)
                .padding(.top, DSSpacing.tiny)
            }
        }
    }
}
