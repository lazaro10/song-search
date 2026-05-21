import Foundation
import AudioPlayer

@MainActor
final class AudioPlayerSpy: AudioPlayer {
    enum Message: Equatable {
        case load(URL)
        case play
        case pause
        case seek(TimeInterval)
        case skip(TimeInterval)
    }

    nonisolated let updates: AsyncStream<AudioPlayerState>
    private let continuation: AsyncStream<AudioPlayerState>.Continuation

    private(set) var messages: [Message] = []
    var errorToThrow: Error?

    nonisolated init() {
        let (stream, continuation) = AsyncStream<AudioPlayerState>.makeStream()
        self.updates = stream
        self.continuation = continuation
    }

    func load(url: URL) async throws {
        messages.append(.load(url))
        if let error = errorToThrow { throw error }
    }

    func play() { messages.append(.play) }
    func pause() { messages.append(.pause) }
    func seek(to time: TimeInterval) { messages.append(.seek(time)) }
    func skip(by interval: TimeInterval) { messages.append(.skip(interval)) }

    func emit(_ state: AudioPlayerState) {
        continuation.yield(state)
    }

    func finish() {
        continuation.finish()
    }
}
