import Foundation
import AVFoundation

@MainActor
public final class AudioPlayerImplementation: AudioPlayer {
    private let player = AVPlayer()
    public nonisolated let updates: AsyncStream<AudioPlayerState>
    private nonisolated let continuation: AsyncStream<AudioPlayerState>.Continuation
    private var timeObserver: Any?

    public init() {
        let (stream, continuation) = AsyncStream<AudioPlayerState>.makeStream()
        self.updates = stream
        self.continuation = continuation
    }

    public func load(url: URL) async throws {
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        installTimeObserverIfNeeded()
        emit()
    }

    public func play() {
        player.play()
        emit()
    }

    public func pause() {
        player.pause()
        emit()
    }

    public func seek(to time: TimeInterval) {
        let target = CMTime(seconds: max(0, time), preferredTimescale: 1000)
        player.seek(to: target) { [weak self] _ in
            Task { @MainActor in self?.emit() }
        }
    }

    public func skip(by interval: TimeInterval) {
        let current = player.currentTime().seconds
        let safeCurrent = current.isFinite ? current : 0
        seek(to: safeCurrent + interval)
    }

    private func installTimeObserverIfNeeded() {
        guard timeObserver == nil else { return }
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in self?.emit() }
        }
    }

    private func emit() {
        continuation.yield(currentState())
    }

    private func currentState() -> AudioPlayerState {
        let current = player.currentTime().seconds
        let dur = player.currentItem?.duration.seconds ?? 0
        return AudioPlayerState(
            isPlaying: player.timeControlStatus == .playing,
            currentTime: current.isFinite ? current : 0,
            duration: dur.isFinite ? dur : 0
        )
    }

    deinit {
        continuation.finish()
    }
}
