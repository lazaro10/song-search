import Foundation

@MainActor
public protocol AudioPlayer {
    nonisolated var updates: AsyncStream<AudioPlayerState> { get }

    func load(url: URL) async throws
    func play()
    func pause()
    func seek(to time: TimeInterval)
    func skip(by interval: TimeInterval)
}
