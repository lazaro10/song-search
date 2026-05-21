import XCTest
import SwiftUI
import DesignSystem

@MainActor
final class DSSpinnerSnapshotTests: XCTestCase {
    func test_defaultSpinner() {
        let view = DSSpinner()
            .frame(width: 120, height: 120)
        assertScreenSnapshot(of: view, layout: .fixed(width: 120, height: 120))
    }
}
