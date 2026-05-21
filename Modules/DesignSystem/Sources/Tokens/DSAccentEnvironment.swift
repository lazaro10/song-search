import SwiftUI

private struct DSAccentKey: EnvironmentKey {
    static let defaultValue: DSAccent = .deepPurple
}

public extension EnvironmentValues {
    var dsAccent: DSAccent {
        get { self[DSAccentKey.self] }
        set { self[DSAccentKey.self] = newValue }
    }
}

public extension View {
    func dsAccent(_ accent: DSAccent) -> some View {
        environment(\.dsAccent, accent)
            .tint(accent.color)
    }
}
