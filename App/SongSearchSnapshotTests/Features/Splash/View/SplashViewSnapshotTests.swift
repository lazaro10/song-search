import XCTest
import SwiftUI
@testable import SongSearch

@MainActor
final class SplashViewSnapshotTests: XCTestCase {
    func test_defaultSplash() {
        let view = SplashView(onComplete: {})
        assertScreenSnapshot(of: view)
    }
}
