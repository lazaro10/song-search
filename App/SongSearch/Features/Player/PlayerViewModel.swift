import Foundation
import Observation
import SongAPI
import AudioPlayer

@MainActor
@Observable
final class PlayerViewModel {
    let song: Song

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
        skipInterval: TimeInterval = 10
    ) {
        self.song = song
        self.audioPlayer = audioPlayer
        self.skipInterval = skipInterval
    }

    func start() async {
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
