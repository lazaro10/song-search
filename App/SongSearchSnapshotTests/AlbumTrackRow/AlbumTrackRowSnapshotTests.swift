import XCTest
import SwiftUI
@testable import SongSearch

@MainActor
final class AlbumTrackRowSnapshotTests: XCTestCase {
    func test_defaultRow() {
        let view = AlbumTrackRow(
            number: 3,
            song: SongFixture.make(name: "Rocket Man", duration: 256),
            showDivider: true
        )
        assertScreenSnapshot(of: view, layout: .device(config: SnapshotHelpers.device))
    }
}
