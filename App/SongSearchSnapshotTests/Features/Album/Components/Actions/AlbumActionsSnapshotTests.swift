import XCTest
import SwiftUI
@testable import SongSearch

@MainActor
final class AlbumActionsSnapshotTests: XCTestCase {
    func test_defaultButtons() {
        let view = AlbumActions(onPlay: {}, onShuffle: {})
        assertScreenSnapshot(of: view, layout: .device(config: SnapshotHelpers.device))
    }
}
