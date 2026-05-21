import XCTest
import SwiftUI
@testable import SongSearch

@MainActor
final class PlayerControlsSnapshotTests: XCTestCase {
    func test_playingState() {
        let view = PlayerControls(
            isPlaying: true,
            onPlayPause: {},
            onSkipBack: {},
            onSkipForward: {}
        )
        assertScreenSnapshot(of: view, layout: .device(config: SnapshotHelpers.device))
    }

    func test_pausedState() {
        let view = PlayerControls(
            isPlaying: false,
            onPlayPause: {},
            onSkipBack: {},
            onSkipForward: {}
        )
        assertScreenSnapshot(of: view, layout: .device(config: SnapshotHelpers.device))
    }
}
