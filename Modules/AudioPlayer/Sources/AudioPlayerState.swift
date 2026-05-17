import Foundation

public struct AudioPlayerState: Sendable, Equatable {
    public let isPlaying: Bool
    public let currentTime: TimeInterval
    public let duration: TimeInterval

    public init(isPlaying: Bool, currentTime: TimeInterval, duration: TimeInterval) {
        self.isPlaying = isPlaying
        self.currentTime = currentTime
        self.duration = duration
    }
}
