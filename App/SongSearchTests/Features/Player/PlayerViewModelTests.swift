import Foundation
import Testing
import SongAPI
import AudioPlayer
@testable import SongSearch

@MainActor
@Suite struct PlayerViewModelTests {
    @Test func initialStateIsLoadingWithoutError() {
        let (sut, _, _) = makeSUT()
        #expect(sut.isLoading == true)
        #expect(sut.errorMessage == nil)
        #expect(sut.isPlaying == false)
        #expect(sut.currentTime == 0)
        #expect(sut.duration == 0)
    }

    @Test func startSetsErrorWhenPreviewURLIsMissing() async {
        let song = SongFixture.make(previewURL: nil)
        let player = AudioPlayerSpy()
        let recents = RecentlyPlayedRepositorySpy()
        let sut = PlayerViewModel(
            song: song,
            audioPlayer: player,
            recentlyPlayedRepository: recents
        )

        await sut.start()

        #expect(sut.isLoading == false)
        #expect(sut.errorMessage != nil)
        #expect(player.messages.isEmpty)
    }

    @Test func startRegistersSongInRecentlyPlayed() async {
        let song = SongFixture.make(id: 42, previewURL: nil)
        let player = AudioPlayerSpy()
        let recents = RecentlyPlayedRepositorySpy()
        let sut = PlayerViewModel(
            song: song,
            audioPlayer: player,
            recentlyPlayedRepository: recents
        )

        await sut.start()

        #expect(recents.addCalls.map(\.id) == [42])
    }

    @Test func startLoadsAndPlaysThenObservesUpdates() async {
        let url = URL(string: "https://example.com/preview.m4a")!
        let song = SongFixture.make(previewURL: url)
        let player = AudioPlayerSpy()
        let recents = RecentlyPlayedRepositorySpy()
        let sut = PlayerViewModel(
            song: song,
            audioPlayer: player,
            recentlyPlayedRepository: recents
        )

        let task = Task { await sut.start() }

        try? await Task.sleep(for: .milliseconds(20))

        player.emit(AudioPlayerState(isPlaying: true, currentTime: 5, duration: 30))
        try? await Task.sleep(for: .milliseconds(20))

        #expect(player.messages.first == .load(url))
        #expect(player.messages.contains(.play))
        #expect(sut.isLoading == false)
        #expect(sut.isPlaying == true)
        #expect(sut.currentTime == 5)
        #expect(sut.duration == 30)

        player.finish()
        await task.value
    }

    @Test func startPausesOnTaskCancellation() async {
        let url = URL(string: "https://example.com/preview.m4a")!
        let player = AudioPlayerSpy()
        let recents = RecentlyPlayedRepositorySpy()
        let sut = PlayerViewModel(
            song: SongFixture.make(previewURL: url),
            audioPlayer: player,
            recentlyPlayedRepository: recents
        )

        let task = Task { await sut.start() }
        try? await Task.sleep(for: .milliseconds(20))

        task.cancel()
        player.finish()
        await task.value

        #expect(player.messages.last == .pause)
    }

    @Test func togglePlayPauseStartsPlaybackWhenStopped() {
        let (sut, player, _) = makeSUT()
        sut.apply(AudioPlayerState(isPlaying: false, currentTime: 0, duration: 30))
        sut.togglePlayPause()
        #expect(player.messages == [.play])
    }

    @Test func togglePlayPausePausesPlaybackWhenPlaying() {
        let (sut, player, _) = makeSUT()
        sut.apply(AudioPlayerState(isPlaying: true, currentTime: 5, duration: 30))
        sut.togglePlayPause()
        #expect(player.messages == [.pause])
    }

    @Test func skipForwardCallsPlayerWithPositiveInterval() {
        let (sut, player, _) = makeSUT(skipInterval: 15)
        sut.skipForward()
        #expect(player.messages == [.skip(15)])
    }

    @Test func skipBackwardCallsPlayerWithNegativeInterval() {
        let (sut, player, _) = makeSUT(skipInterval: 15)
        sut.skipBackward()
        #expect(player.messages == [.skip(-15)])
    }

    @Test func applyIgnoresZeroDurationOnceKnown() {
        let (sut, _, _) = makeSUT()
        sut.apply(AudioPlayerState(isPlaying: true, currentTime: 5, duration: 30))
        sut.apply(AudioPlayerState(isPlaying: true, currentTime: 6, duration: 0))
        #expect(sut.duration == 30)
        #expect(sut.currentTime == 6)
    }

    // MARK: - Helpers

    private func makeSUT(skipInterval: TimeInterval = 10) -> (
        sut: PlayerViewModel,
        player: AudioPlayerSpy,
        recents: RecentlyPlayedRepositorySpy
    ) {
        let player = AudioPlayerSpy()
        let recents = RecentlyPlayedRepositorySpy()
        let sut = PlayerViewModel(
            song: SongFixture.make(previewURL: URL(string: "https://example.com/preview.m4a")),
            audioPlayer: player,
            recentlyPlayedRepository: recents,
            skipInterval: skipInterval
        )
        return (sut, player, recents)
    }
}
