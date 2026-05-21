import XCTest
import SwiftUI
@testable import SongSearch

@MainActor
final class AlbumHeaderSnapshotTests: XCTestCase {
    func test_defaultHeader() {
        let view = AlbumHeader(album: AlbumFixture.make())
        assertScreenSnapshot(of: view, layout: .device(config: SnapshotHelpers.device))
    }
}
