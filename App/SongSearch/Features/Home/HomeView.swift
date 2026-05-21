import SwiftUI
import SongAPI
import DesignSystem
import Localization

struct HomeView: View {
    @Environment(\.dsPalette) private var palette
    @Environment(AppRouter.self) private var router
    @Bindable var viewModel: HomeViewModel
    @State private var selectedSongForOptions: Song?

    var body: some View {
        @Bindable var search = viewModel.search

        ScrollView {
            LazyVStack(spacing: 0) {
                HomeTitleBar()
                    .padding(.horizontal, DSSpacing.spacious)
                    .padding(.top, DSSpacing.small)
                    .padding(.bottom, DSSpacing.medium)

                HomeSearchBar(text: $search.term)
                    .padding(.horizontal, DSSpacing.spacious)
                    .padding(.bottom, DSSpacing.large)

                if search.term.isEmpty, !viewModel.recentlyPlayed.isEmpty {
                    RecentlyPlayedRail(songs: viewModel.recentlyPlayed)
                }

                resultsSection
            }
            .padding(.bottom, DSSpacing.huge)
        }
        .background(palette.background.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.onAppear()
        }
        .onChange(of: search.term) { _, _ in
            viewModel.processSearchTermChange()
        }
        .sheet(item: $selectedSongForOptions) { song in
            MoreOptionsBuilder.build(song: song) { albumId in
                router.navigate(to: .album(collectionId: albumId))
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }

    @ViewBuilder
    private var resultsSection: some View {
        switch viewModel.search.state {
        case .idle:
            if viewModel.recentlyPlayed.isEmpty {
                DSEmptyState(
                    systemImage: "magnifyingglass",
                    title: L10n.Home.emptyTitle,
                    message: L10n.Home.emptyMessage
                )
                .padding(.top, DSSpacing.big)
            }

        case .loading:
            HStack { Spacer(); DSSpinner(accessibilityLabel: L10n.A11y.loading); Spacer() }
                .padding(.vertical, DSSpacing.huge)

        case let .content(songs):
            if !viewModel.restoredFromCache {
                DSSectionHeader(title: L10n.Home.resultsFor(viewModel.search.term))
            }

            ForEach(Array(songs.enumerated()), id: \.element.id) { index, song in
                NavigationLink(value: AppRoute.player(song)) {
                    SongRow(
                        song: song,
                        showDivider: index < songs.count - 1,
                        onMore: { selectedSongForOptions = song }
                    )
                }
                .buttonStyle(.plain)
                .onAppear {
                    if index == max(0, songs.count - 3) {
                        Task { await viewModel.search.loadMoreIfNeeded() }
                    }
                }
            }

            paginationFooter
                .padding(.vertical, DSSpacing.large)

        case .empty:
            DSEmptyState(
                systemImage: "music.note.list",
                title: L10n.Home.noSongsTitle,
                message: L10n.Home.noSongsMessage(viewModel.search.term)
            )

        case let .error(message):
            DSEmptyState(
                systemImage: "exclamationmark.triangle",
                title: L10n.Common.errorTitle,
                message: message,
                actionTitle: L10n.Common.tryAgain,
                action: { Task { await viewModel.search.retry() } }
            )
        }
    }

    @ViewBuilder
    private var paginationFooter: some View {
        if viewModel.search.isPaginating {
            VStack(spacing: DSSpacing.small) {
                DSSpinner()
                Text(L10n.Home.loadingMore)
                    .font(.dsCaptionSmall)
                    .foregroundStyle(palette.textSecondary)
            }
            .frame(maxWidth: .infinity)
        } else if let message = viewModel.search.paginationError {
            VStack(spacing: DSSpacing.small) {
                Text(message)
                    .font(.dsCaptionSmall)
                    .foregroundStyle(palette.textSecondary)
                    .multilineTextAlignment(.center)
                Button(L10n.Home.tapToRetry) {
                    Task { await viewModel.search.retryPagination() }
                }
                .font(.dsCaption)
                .tint(.accentColor)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
