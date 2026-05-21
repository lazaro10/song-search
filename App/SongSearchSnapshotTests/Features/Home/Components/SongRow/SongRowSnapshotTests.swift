import XCTest
import SwiftUI
@testable import SongSearch

@MainActor
final class SongRowSnapshotTests: XCTestCase {
    func test_defaultRow() {
        let view = SongRow(
            song: SongFixture.make(name: "Yesterday", artistName: "The Beatles", duration: 125),
            showDivider: true,
            onMore: {}
        )
        assertScreenSnapshot(of: view, layout: .device(config: SnapshotHelpers.device))
    }
}
