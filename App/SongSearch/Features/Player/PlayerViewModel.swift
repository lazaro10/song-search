import Foundation
import Observation
import SongAPI
import AudioPlayer
import Storage

@MainActor
@Observable
final class PlayerViewModel {
    let song: Song
    let recentlyPlayedRepository: any RecentlyPlayedRepository

    private(set) var isLoading = true
    private(set) var errorMessage: String?
    private(set) var isPlaying = false
    private(set) var currentTime: TimeInterval = 0
    private(set) var duration: TimeInterval = 0

    private let audioPlayer: AudioPlayer
    private let skipInterval: TimeInterval

    init(
        song: Song,
        audioPlayer: AudioPlayer,
        recentlyPlayedRepository: any RecentlyPlayedRepository,
        skipInterval: TimeInterval = 10
    ) {
        self.song = song
        self.audioPlayer = audioPlayer
        self.recentlyPlayedRepository = recentlyPlayedRepository
        self.skipInterval = skipInterval
    }

    /// Loads the song's preview, starts playback, and then observes the player's
    /// update stream until cancellation.
    ///
    /// Designed to be invoked from a SwiftUI `.task { await viewModel.start() }`:
    /// the `for await` loop runs until the player's stream finishes or the
    /// surrounding Task is cancelled (which happens when the view disappears).
    /// The `defer { audioPlayer.pause() }` then halts playback, so the audio
    /// stops cleanly when the user leaves the screen. If you call `start()`
    /// from a context that isn't cancelled on view disappear, you're
    /// responsible for stopping playback yourself.
    func start() async {
        await recentlyPlayedRepository.add(song)

        guard let url = song.previewURL else {
            isLoading = false
            errorMessage = "Preview not available for this song."
            return
        }
        defer { audioPlayer.pause() }
        do {
            try await audioPlayer.load(url: url)
            isLoading = false
            audioPlayer.play()
            for await state in audioPlayer.updates {
                apply(state)
            }
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }

    func togglePlayPause() {
        if isPlaying { audioPlayer.pause() } else { audioPlayer.play() }
    }

    func skipForward() {
        audioPlayer.skip(by: skipInterval)
    }

    func skipBackward() {
        audioPlayer.skip(by: -skipInterval)
    }

    func apply(_ state: AudioPlayerState) {
        isPlaying = state.isPlaying
        currentTime = state.currentTime
        if state.duration > 0 { duration = state.duration }
    }
}
