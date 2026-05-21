import XCTest
import SwiftUI
import DesignSystem

@MainActor
final class DSEmptyStateSnapshotTests: XCTestCase {
    func test_withActionButton() {
        let view = DSEmptyState(
            icon: .warning,
            title: "Something went wrong",
            message: "We couldn\u{2019}t load the album. Check your connection and try again.",
            actionTitle: "Try Again",
            action: {}
        )
        assertScreenSnapshot(of: view)
    }

    func test_withoutActionButton() {
        let view = DSEmptyState(
            icon: .search,
            title: "Search for a song",
            message: "Type a song or artist name above to start exploring."
        )
        assertScreenSnapshot(of: view)
    }
}
