import XCTest
import SwiftUI
import DesignSystem

@MainActor
final class DSCoverArtSnapshotTests: XCTestCase {
    func test_placeholderWhenURLIsNil() {
        let view = DSCoverArt(url: nil, size: 96, cornerRadius: 12)
            .frame(width: 120, height: 120)
        assertScreenSnapshot(of: view, layout: .fixed(width: 120, height: 120))
    }
}
