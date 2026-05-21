import SwiftUI
import SnapshotTesting
import Networking
@testable import DesignSystem

enum SnapshotHelpers {
    nonisolated(unsafe) static let device: ViewImageConfig = .iPhone13Pro

    @MainActor
    static func wrap<Content: View>(_ content: Content) -> some View {
        content
            .environment(NetworkReachability())
            .dsAccent(.deepPurple)
    }
}

@MainActor
func assertScreenSnapshot<V: View>(
    of view: V,
    layout: SwiftUISnapshotLayout = .device(config: SnapshotHelpers.device),
    fileID: StaticString = #fileID,
    file filePath: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line,
    column: UInt = #column
) {
    assertSnapshot(
        of: SnapshotHelpers.wrap(view),
        as: .image(layout: layout),
        fileID: fileID,
        file: filePath,
        testName: testName,
        line: line,
        column: column
    )
}
